import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data_layer/mappings/payment/biller_dto_mapping.dart';
import '../../../data_layer/network/net_exceptions.dart';
import '../../../domain_layer/models/account/account.dart';
import '../../../domain_layer/models/bill/bill.dart';
import '../../../domain_layer/models/payment/biller.dart';
import '../../../domain_layer/models/payment/payment.dart';
import '../../../domain_layer/models/service/service_field.dart';
import '../../../domain_layer/models/shortcut/new_shortcut.dart';
import '../../../domain_layer/use_cases/account/get_accounts_by_status_use_case.dart';
import '../../../domain_layer/use_cases/payments/generate_device_uid_use_case.dart';
import '../../../domain_layer/use_cases/payments/load_billers_use_case.dart';
import '../../../domain_layer/use_cases/payments/load_services_use_case.dart';
import '../../../domain_layer/use_cases/payments/post_payment_use_case.dart';
import '../../../domain_layer/use_cases/payments/validate_bill_use_case.dart';
import '../../../domain_layer/use_cases/shortcut/create_shortcut_use_case.dart';
import 'pay_bill_state.dart';

/// A cubit for paying customer bills.
class PayBillCubit extends Cubit<PayBillState> {
  final LoadBillersUseCase _loadBillersUseCase;
  final LoadServicesUseCase _loadServicesUseCase;
  final GetAccountsByStatusUseCase _getCustomerAccountsUseCase;
  final PostPaymentUseCase _postPaymentUseCase;
  final GenerateDeviceUIDUseCase _generateDeviceUIDUseCase;
  final ValidateBillUseCase _validateBillUseCase;
  final CreateShortcutUseCase _createShortcutUseCase;

  /// The biller id to pay for, if provided the biller will be pre-selected
  /// when the cubit loads.
  final String? billerId;

  /// Creates a new cubit
  PayBillCubit({
    required LoadBillersUseCase loadBillersUseCase,
    required LoadServicesUseCase loadServicesUseCase,
    required GetAccountsByStatusUseCase getCustomerAccountsUseCase,
    required PostPaymentUseCase postPaymentUseCase,
    required GenerateDeviceUIDUseCase generateDeviceUIDUseCase,
    required ValidateBillUseCase validateBillUseCase,
    required CreateShortcutUseCase createShortcutUseCase,
    this.billerId,
  })  : _loadBillersUseCase = loadBillersUseCase,
        _loadServicesUseCase = loadServicesUseCase,
        _getCustomerAccountsUseCase = getCustomerAccountsUseCase,
        _postPaymentUseCase = postPaymentUseCase,
        _generateDeviceUIDUseCase = generateDeviceUIDUseCase,
        _validateBillUseCase = validateBillUseCase,
        _createShortcutUseCase = createShortcutUseCase,
        super(PayBillState());

  /// Loads all the required data, must be called at lease once before anything
  /// other method in this cubit.
  void load() async {
    emit(
      state.copyWith(
        busy: true,
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
          busy: false,
          billers: billers,
          fromAccounts: accounts
              .where((element) => element.canPay)
              .toList(growable: false),
          billerCategories: billers.toBillerCategories(),
          errorStatus: PayBillErrorStatus.none,
        ),
      );

      if (billerId?.isNotEmpty ?? false) {
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
          busy: false,
          errorStatus: e is NetException
              ? PayBillErrorStatus.network
              : PayBillErrorStatus.generic,
        ),
      );
    }
  }

  /// Validates user input and returns the bill object
  Future<Bill> validateBill() async {
    try {
      emit(
        state.copyWith(
          busy: true,
          busyAction: PayBillBusyAction.validating,
        ),
      );
      final validatedBill = await _validateBillUseCase(bill: state.bill);
      emit(
        state.copyWith(
          busy: false,
          validatedBill: validatedBill,
        ),
      );
      return validatedBill;
    } on Exception catch (_) {
      emit(
        state.copyWith(
          busy: false,
        ),
      );

      rethrow;
    }
  }

  /// Submits the payment
  Future<Payment> submit({
    String? otp,
    Payment? payment,
  }) async {
    try {
      emit(
        state.copyWith(
          busy: true,
          busyAction: PayBillBusyAction.submitting,
          deviceUID: _generateDeviceUIDUseCase(30),
        ),
      );

      final res = await _postPaymentUseCase.pay(
        payment ?? state.payment,
        otp: otp,
      );

      if ((state.payment.saveToShortcut) && (res.status != PaymentStatus.otp)) {
        await _createShortcut(res);
      }

      emit(
        state.copyWith(
          busy: false,
        ),
      );

      return res;
    } on Exception catch (_) {
      emit(
        state.copyWith(
          busy: false,
        ),
      );
      rethrow;
    }
  }

  /// Creates the shortcut (if enabled) once the bill payment has succeeded.
  Future<void> _createShortcut(
    Payment payment,
  ) async {
    emit(
      state.copyWith(
        busy: true,
        busyAction: PayBillBusyAction.addingShortcut,
      ),
    );

    try {
      await _createShortcutUseCase(
        shortcut: NewShortcut(
          name: state.payment.shortcutName!,
          type: ShortcutType.payment,
          payload: state.payment,
        ),
      );

      emit(
        state.copyWith(
          busy: false,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          errorStatus: e is NetException
              ? PayBillErrorStatus.network
              : PayBillErrorStatus.generic,
        ),
      );
      rethrow;
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
  void setSaveToShortcut({bool? saveToShortcuts}) {
    emit(
      state.copyWith(
        paymentToBeMade: state.paymentToBeMade?.copyWith(
          saveToShortcut: saveToShortcuts,
        ),
      ),
    );
  }

  /// Set's the shortcut name
  void setShortcutName({String? shortcutName}) {
    emit(
      state.copyWith(
        paymentToBeMade: state.paymentToBeMade?.copyWith(
          shortcutName: shortcutName,
        ),
      ),
    );
  }

  /// Set's the selected biller to the one matching the provided biller id.
  ///
  /// This will trigger a request to fetch the services for the selected biller.
  void setBiller(String billerId) async {
    final biller =
        state.billers.firstWhereOrNull((element) => element.id == billerId);
    if (biller == null) return;
    emit(
      state.copyWith(
        selectedBiller: biller,
        busy: true,
        busyAction: PayBillBusyAction.loadingServices,
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
          busy: false,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          errorStatus: e is NetException
              ? PayBillErrorStatus.network
              : PayBillErrorStatus.generic,
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
}
