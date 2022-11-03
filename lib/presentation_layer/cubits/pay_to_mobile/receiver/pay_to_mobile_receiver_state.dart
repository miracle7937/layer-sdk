import 'dart:collection';

import '../../../../domain_layer/models.dart';
import '../../../cubits.dart';
import 'pay_to_mobile_receiver_cubit.dart';

/// Available busy actions for the cubit
enum PayToMobileReceiverActions {
  /// Is loading data
  loadingData,

  /// Is posting the payment
  submit,
}

/// The available events that the cubit can emit.
enum PayToMobileReceiverEvent {
  /// Event for showing a success dialog
  showSuccessDialog,
}

/// Class that holds the state used in [PayToMobileReceiverCubit]
class PayToMobileReceiverState extends BaseState<PayToMobileReceiverActions,
    PayToMobileReceiverEvent, void> {
  /// Id of the sendMoney request
  final String sendMoneyId;

  /// Id of the account that will receive
  final String accountId;

  /// The withdrawal code
  final String withdrawalCode;

  /// The withdrawal pin number
  final String withdrawalPin;

  /// The transfer reason
  final String reason;

  /// The beneficiary
  final Beneficiary? beneficiary;

  /// A list of [Account]s to be selected by the user
  final UnmodifiableListView<Account> accounts;

  /// The [Account] selected by the user
  final Account? selectedAccount;

  /// The [Bank] for the selected account
  final Bank? bank;

  /// The device UUID
  final String deviceUUID;

  /// Creates a new [PayToMobileReceiverState]
  PayToMobileReceiverState({
    super.actions = const <PayToMobileReceiverActions>{},
    super.errors = const <CubitError>{},
    super.events = const <PayToMobileReceiverEvent>{},
    required this.deviceUUID,
    Iterable<Account> accounts = const [],
    this.sendMoneyId = '',
    this.accountId = '',
    this.withdrawalCode = '',
    this.withdrawalPin = '',
    this.reason = '',
    this.beneficiary,
    this.selectedAccount,
    this.bank,
  }) : accounts = UnmodifiableListView(accounts);

  @override
  PayToMobileReceiverState copyWith({
    String? sendMoneyId,
    String? accountId,
    String? withdrawalCode,
    String? withdrawalPin,
    String? reason,
    Beneficiary? beneficiary,
    Iterable<Account>? accounts,
    Account? selectedAccount,
    Bank? bank,
    Set<PayToMobileReceiverActions>? actions,
    Set<CubitError>? errors,
    Set<PayToMobileReceiverEvent>? events,
    String? deviceUUID,
  }) {
    return PayToMobileReceiverState(
      sendMoneyId: sendMoneyId ?? this.sendMoneyId,
      accountId: accountId ?? this.accountId,
      withdrawalCode: withdrawalCode ?? this.withdrawalCode,
      withdrawalPin: withdrawalPin ?? this.withdrawalPin,
      reason: reason ?? this.reason,
      beneficiary: beneficiary ?? this.beneficiary,
      accounts: accounts ?? this.accounts,
      selectedAccount: selectedAccount ?? this.selectedAccount,
      bank: bank ?? this.bank,
      actions: actions ?? super.actions,
      errors: errors ?? super.errors,
      events: events ?? super.events,
      deviceUUID: deviceUUID ?? this.deviceUUID,
    );
  }

  @override
  List<Object?> get props => [
        sendMoneyId,
        accountId,
        withdrawalCode,
        withdrawalPin,
        reason,
        beneficiary,
        accounts,
        selectedAccount,
        bank,
        errors,
        actions,
        events,
      ];
}
