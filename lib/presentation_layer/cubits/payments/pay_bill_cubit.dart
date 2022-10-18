import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data_layer/mappings/payment/biller_dto_mapping.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../../domain_layer/use_cases/payments/generate_device_uid_use_case.dart';
import '../../../domain_layer/use_cases/payments/load_billers_use_case.dart';
import '../../../domain_layer/use_cases/payments/load_services_use_case.dart';
import '../../../domain_layer/use_cases/payments/post_payment_use_case.dart';
import '../../../domain_layer/use_cases/payments/validate_bill_use_case.dart';
import '../../cubits.dart';
import 'pay_bill_state.dart';

/// A cubit for paying customer bills.
class PayBillCubit extends Cubit<PayBillState> {
  final LoadBillersUseCase _loadBillersUseCase;
  final LoadServicesUseCase _loadServicesUseCase;
  final GetAccountsByStatusUseCase _getCustomerAccountsUseCase;
  final PostPaymentUseCase _postPaymentUseCase;
  final ValidateBillUseCase _validateBillUseCase;
  final CreateShortcutUseCase _createShortcutUseCase;
  final ResendOTPPaymentUseCase _resendOTPUseCase;

  /// The biller id to pay for, if provided the biller will be pre-selected
  /// when the cubit loads.
  final String? billerId;

  /// A payment to repeat
  final Payment? paymentToRepeat;

  /// Creates a new cubit
  PayBillCubit({
    required LoadBillersUseCase loadBillersUseCase,
    required LoadServicesUseCase loadServicesUseCase,
    required GetAccountsByStatusUseCase getCustomerAccountsUseCase,
    required PostPaymentUseCase postPaymentUseCase,
    required GenerateDeviceUIDUseCase generateDeviceUIDUseCase,
    required ValidateBillUseCase validateBillUseCase,
    required CreateShortcutUseCase createShortcutUseCase,
    required ResendOTPPaymentUseCase resendPaymentOTPUseCase,
    this.billerId,
    this.paymentToRepeat,
  })  : _loadBillersUseCase = loadBillersUseCase,
        _loadServicesUseCase = loadServicesUseCase,
        _getCustomerAccountsUseCase = getCustomerAccountsUseCase,
        _postPaymentUseCase = postPaymentUseCase,
        _validateBillUseCase = validateBillUseCase,
        _createShortcutUseCase = createShortcutUseCase,
        _resendOTPUseCase = resendPaymentOTPUseCase,
        super(PayBillState(
          deviceUID: generateDeviceUIDUseCase(30),
        ));

  /// Loads all the required data, must be called at least once before anything
  /// other method in this cubit.
  void load() async {
    emit(
      state.copyWith(
        actions: state.addAction(
          PayBillBusyAction.loading,
        ),
        errors: state.removeErrorForAction(
          PayBillBusyAction.loading,
        ),
      ),
    );

    try {
      final responses = await Future.wait([
        _loadBillersUseCase(),
        _getCustomerAccountsUseCase(
          statuses: [
            AccountStatus.active,
          ],
          includeDetails: false,
        ),
      ]);

      final billers = responses[0] as List<Biller>;
      final accounts = responses[1] as List<Account>;

      emit(
        state.copyWith(
          actions: state.removeAction(PayBillBusyAction.loading),
          billers: billers,
          fromAccounts: accounts
              .where((element) => element.canPay)
              .toList(growable: false),
          billerCategories: billers.toBillerCategories(),
        ),
      );

      if (paymentToRepeat != null) {
        if (paymentToRepeat!.bill?.service?.billerId != null) {
          final biller = billers.firstWhereOrNull((element) =>
              element.id == paymentToRepeat!.bill?.service?.billerId);
          if (biller != null) {
            setFromAccount(paymentToRepeat!.fromAccount?.id);
            setAmount(paymentToRepeat!.amount ?? 0.0);
            setCatogery(biller.category.categoryCode);
            await setBiller(biller.id);
            setService(paymentToRepeat!.bill?.service?.serviceId);
            _setServiceFieldsValue(
              serviceFields: paymentToRepeat!.bill?.billingFields,
            );
            setScheduleDetails(
              scheduleDetails: ScheduleDetails(
                recurrence: paymentToRepeat!.recurrence,
                startDate: paymentToRepeat!.scheduled ??
                    paymentToRepeat!.recurrenceStart,
                endDate: paymentToRepeat!.recurrenceEnd,
              ),
            );
          }
        }
      } else if (billerId?.isNotEmpty ?? false) {
        final biller =
            billers.firstWhereOrNull((element) => element.id == billerId);
        if (biller != null) {
          setCatogery(biller.category.categoryCode);
          setBiller(biller.id);
        }
      }
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            PayBillBusyAction.loading,
          ),
          errors: state.addErrorFromException(
            action: PayBillBusyAction.loading,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Validates user input and returns the bill object
  Future<void> validateBill() async {
    emit(
      state.copyWith(
        actions: state.addAction(
          PayBillBusyAction.validating,
        ),
        errors: state.removeErrorForAction(
          PayBillBusyAction.validating,
        ),
      ),
    );

    try {
      final validatedBill = await _validateBillUseCase(bill: state.bill);

      emit(
        state.copyWith(
          validatedBill: validatedBill,
          actions: state.removeAction(
            PayBillBusyAction.validating,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            PayBillBusyAction.validating,
          ),
          errors: state.addErrorFromException(
            action: PayBillBusyAction.validating,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Submits the payment
  Future<void> submit() async {
    emit(
      state.copyWith(
        actions: state.addAction(
          PayBillBusyAction.submitting,
        ),
        errors: state.removeErrorForAction(
          PayBillBusyAction.submitting,
        ),
        events: state.removeEvent(
          PayBillEvent.showConfirmationView,
        ),
      ),
    );

    try {
      final returnedPayment = await _postPaymentUseCase(
        state.payment,
      );

      switch (returnedPayment.status) {
        case PaymentStatus.completed:
        case PaymentStatus.pending:
        case PaymentStatus.scheduled:
        case PaymentStatus.pendingBank:
          if (state.saveToShortcut) {
            await _createShortcut(returnedPayment);
          }

          emit(
            state.copyWith(
              actions: state.removeAction(
                PayBillBusyAction.submitting,
              ),
              returnedPayment: returnedPayment,
              events: state.addEvent(
                PayBillEvent.showResultView,
              ),
            ),
          );
          break;

        case PaymentStatus.failed:
          emit(
            state.copyWith(
              actions: state.removeAction(
                PayBillBusyAction.submitting,
              ),
              errors: state.addCustomCubitError(
                action: PayBillBusyAction.submitting,
                code: CubitErrorCode.paymentFailed,
              ),
            ),
          );
          break;

        case PaymentStatus.otp:
          emit(
            state.copyWith(
              actions: state.removeAction(
                PayBillBusyAction.submit,
              ),
              returnedPayment: returnedPayment,
              events: state.addEvent(
                PayBillEvent.openSecondFactor,
              ),
            ),
          );
          break;

        default:
          throw Exception(
            'Unhandled payment status -> ${returnedPayment.status}',
          );
      }

      emit(
        state.copyWith(
          actions: state.removeAction(
            PayBillBusyAction.submitting,
          ),
          returnedPayment: returnedPayment,
          events: state.addEvent(
            PayBillEvent.showConfirmationView,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            PayBillBusyAction.submitting,
          ),
          errors: state.addErrorFromException(
            action: PayBillBusyAction.submitting,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Validates the second factor for this payment.
  Future<void> validateSecondFactor({
    String? otp,
  }) async {
    assert(state.returnedPayment != null);

    emit(
      state.copyWith(
        actions: state.addAction(
          PayBillBusyAction.validatingSecondFactor,
        ),
        errors: state.removeErrorForAction(
          PayBillBusyAction.validatingSecondFactor,
        ),
        events: state.removeEvent(
          PayBillEvent.inputOTPCode,
        ),
      ),
    );

    try {
      final returnedPayment = await _postPaymentUseCase(
        state.returnedPayment!,
        otp: otp,
      );

      emit(
        state.copyWith(
          actions: state.removeAction(
            PayBillBusyAction.validatingSecondFactor,
          ),
          returnedPayment: returnedPayment,
          events: state.addEvent(PayBillEvent.inputOTPCode),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            otp != null
                ? PayBillBusyAction.validatingSecondFactor
                : PayBillBusyAction.submitting,
          ),
          errors: state.addErrorFromException(
            action: otp != null
                ? PayBillBusyAction.validatingSecondFactor
                : PayBillBusyAction.submitting,
            exception: e,
          ),
        ),
      );
    }
  }

  /// TODO: cubit_issue | This is the payment that we have on the state, right?
  /// I think it would be better to use that one and add an assert.
  ///
  /// Resend an OTP request
  Future<void> resendOTP(Payment payment) async {
    try {
      emit(
        state.copyWith(
          actions: state.addAction(
            PayBillBusyAction.resendingOTP,
          ),
          errors: state.removeErrorForAction(
            PayBillBusyAction.resendingOTP,
          ),
        ),
      );

      await _resendOTPUseCase(
        payment,
      );

      emit(
        state.copyWith(
          actions: state.removeAction(
            PayBillBusyAction.resendingOTP,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            PayBillBusyAction.resendingOTP,
          ),
          errors: state.addErrorFromException(
            action: PayBillBusyAction.resendingOTP,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Creates the shortcut (if enabled) once the bill payment has succeeded.
  Future<void> _createShortcut(
    Payment payment,
  ) async {
    try {
      await _createShortcutUseCase(
        shortcut: NewShortcut(
          name: state.shortcutName!,
          type: ShortcutType.payment,
          payload: state.payment,
        ),
      );
    } on Exception catch (_) {
      // TODO: handle shortcut error without affecting the payment
    }
  }

  /// Set's the selected category to the one matching the provided category
  /// code.
  void setCatogery(String categoryCode) {
    final category = state.billerCategories
        .firstWhereOrNull((e) => e.categoryCode == categoryCode);
    emit(
      state.copyWith(
        selectedCategory: category,
      ),
    );
  }

  /// Set's save to shortcuts bool
  void setSaveToShortcut({
    required bool saveToShortcuts,
  }) {
    emit(
      state.copyWith(
        saveToShortcut: saveToShortcuts,
      ),
    );
  }

  /// Set's the shortcut name
  void setShortcutName(String shortcutName) {
    emit(
      state.copyWith(
        shortcutName: shortcutName,
      ),
    );
  }

  /// Set's the selected biller to the one matching the provided biller id.
  ///
  /// This will trigger a request to fetch the services for the selected biller.
  Future<void> setBiller(String billerId) async {
    final biller =
        state.billers.firstWhereOrNull((element) => element.id == billerId);
    if (biller == null) return;

    emit(
      state.copyWith(
        selectedBiller: biller,
        actions: state.addAction(
          PayBillBusyAction.loadingServices,
        ),
        errors: state.removeErrorForAction(
          PayBillBusyAction.loadingServices,
        ),
      ),
    );

    try {
      final services = await _loadServicesUseCase(
        billerId: billerId,
        sortByName: true,
      );

      emit(
        state.copyWith(
          services: services,
          selectedService: services.firstOrNull,
          serviceFields: services.firstOrNull?.serviceFields,
          actions: state.removeAction(
            PayBillBusyAction.loadingServices,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            PayBillBusyAction.loadingServices,
          ),
          errors: state.addErrorFromException(
            action: PayBillBusyAction.loadingServices,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Sets the selected account to the one matching the provided account id.
  void setFromAccount(String? accountId) {
    final selectedAccount = state.fromAccounts.firstWhereOrNull(
      (e) => e.id == accountId,
    );
    emit(
      state.copyWith(
        selectedAccount: selectedAccount,
      ),
    );
  }

  /// Sets the amount of the payment
  void setAmount(double amount) {
    emit(
      state.copyWith(
        amount: amount,
      ),
    );
  }

  /// Sets the selected biller service
  void setService(int? serviceId) {
    final service = state.services
        .firstWhereOrNull((element) => element.serviceId == serviceId);

    emit(
      state.copyWith(
        selectedService: service,
        serviceFields: service?.serviceFields ?? [],
      ),
    );
  }

  /// Loops over the service fields and sets their values
  void _setServiceFieldsValue({List<ServiceField>? serviceFields}) {
    if (serviceFields?.isEmpty ?? true) return;
    for (var i = 0; i < serviceFields!.length; i++) {
      setServiceFieldValue(
        id: serviceFields[i].fieldId,
        value: serviceFields[i].value ?? "",
      );
    }
  }

  /// Sets the provided value for the service field matching the provided id
  void setServiceFieldValue({
    required int id,
    required String value,
  }) {
    final newFields = <ServiceField>[];
    for (var i = 0; i < state.serviceFields.length; i++) {
      final field = state.serviceFields[i];
      if (field.fieldId == id) {
        newFields.add(field.copyWith(value: value));
      } else {
        newFields.add(field);
      }
    }
    emit(
      state.copyWith(serviceFields: newFields),
    );
  }

  /// Set the payments scheduling details
  void setScheduleDetails({required ScheduleDetails scheduleDetails}) {
    emit(
      state.copyWith(
        scheduleDetails: scheduleDetails,
      ),
    );
  }
}
