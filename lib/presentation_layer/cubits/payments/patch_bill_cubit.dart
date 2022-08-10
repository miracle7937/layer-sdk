import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data_layer/network.dart';
import '../../../data_layer/network/net_exceptions.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../../domain_layer/use_cases/payments/generate_device_uid_use_case.dart';
import '../../../domain_layer/use_cases/payments/validate_bill_use_case.dart';
import '../../../layer_sdk.dart';
import 'patch_bill_state.dart';

/// A cubit for patching customer bills.
class PatchBillCubit extends Cubit<PatchBillState> {
  final GetAccountsByStatusUseCase _getCustomerAccountsUseCase;
  final PatchPaymentUseCase _patchPaymentUseCase;
  final ValidateBillUseCase _validateBillUseCase;
  final CreateShortcutUseCase _createShortcutUseCase;

  /// A payment to patch
  // final Payment? paymentToPatch;

  /// Creates a new cubit
  PatchBillCubit({
    required GetAccountsByStatusUseCase getCustomerAccountsUseCase,
    required PatchPaymentUseCase patchPaymentUseCase,
    required GenerateDeviceUIDUseCase generateDeviceUIDUseCase,
    required ValidateBillUseCase validateBillUseCase,
    required CreateShortcutUseCase createShortcutUseCase,
    // this.paymentToPatch,
  })  : _getCustomerAccountsUseCase = getCustomerAccountsUseCase,
        _patchPaymentUseCase = patchPaymentUseCase,
        _validateBillUseCase = validateBillUseCase,
        _createShortcutUseCase = createShortcutUseCase,
        super(PatchBillState(payment: Payment()));

  /// Loads all the required data, must be called at lease once before anything
  /// other method in this cubit.
  void load(Payment payment) async {
    emit(
      state.copyWith(
        busy: true,
        payment: payment,
      ),
    );
    try {
      final responses = await Future.wait([
        _getCustomerAccountsUseCase(
          statuses: [
            AccountStatus.active,
          ],
          includeDetails: false,
        ),
      ]);

      final accounts = responses[0] as List<Account>;

      emit(
        state.copyWith(
          busy: false,
          fromAccounts: accounts
              .where((element) => element.canPay)
              .toList(growable: false),
          errorStatus: PatchBillErrorStatus.none,
        ),
      );

      // if (paymentToPatch!.bill?.service?.billerId != null) {
      //   final biller = billers.firstWhereOrNull(
      //       (element) => element.id == paymentToPatch!.bill?.service?.billerId);
      //   if (biller != null) {
      //     setFromAccount(paymentToPatch!.fromAccount?.id);
      //     setAmount(paymentToPatch!.amount ?? 0.0);
      //     TODO: set recurrence
      // }
      // }
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          errorStatus: e is NetException
              ? PatchBillErrorStatus.network
              : PatchBillErrorStatus.generic,
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
          busyAction: PatchBillBusyAction.validating,
        ),
      );
      final validatedBill =
          await _validateBillUseCase(bill: state.payment.bill ?? Bill());
      emit(
        state.copyWith(
          busy: false,
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
          busyAction: otp != null
              ? PatchBillBusyAction.validatingSecondFactor
              : PatchBillBusyAction.submitting,
        ),
      );

      final res = await _patchPaymentUseCase.patch(
        payment ?? state.payment,
        otp: otp,
      );

      if ((state.saveToShortcut) &&
          ([
            PaymentStatus.completed,
            PaymentStatus.pending,
            PaymentStatus.scheduled,
            PaymentStatus.pendingBank,
          ].contains(res.status))) {
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

  /// Sets the selected account to the one matching the provided account id.
  void setFromAccount(String? accountId) {
    final selectedAccount = state.fromAccounts.firstWhereOrNull(
      (e) => e.id == accountId,
    );
    emit(
      state.copyWith(
        payment: state.payment.copyWith(fromAccount: selectedAccount),
      ),
    );
  }

  /// Sets the amount of the payment
  void setAmount(double amount) {
    emit(
      state.copyWith(
        payment: state.payment.copyWith(amount: amount),
      ),
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
