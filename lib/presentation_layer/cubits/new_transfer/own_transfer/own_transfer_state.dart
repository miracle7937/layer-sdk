import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../../domain_layer/models.dart';

/// The actions that the cubit can perform.
enum OwnTransferAction {
  /// The accounts are being loaded.
  accounts,

  /// The accounts have been loaded, but the user doesn't have enough valid own
  /// accounts to transfer between them.
  notEnoughAccounts,

  /// The submit is being processed.
  submit,

  /// The receipt type is image.
  imageReceipt,

  /// The receipt type is pdf.
  pdfReceipt,

  /// The shortcut is being created.
  shortcut,

  /// Validating funds
  validatingFunds
}

/// The state of the own transfer flow.
class OwnTransferState extends Equatable {
  /// The new transfer data.
  final OwnTransfer transfer;

  /// The source accounts available for selection.
  final UnmodifiableListView<Account> fromAccounts;

  /// The destination accounts available for selection.
  final UnmodifiableListView<Account> toAccounts;

  /// The currencies list.
  final UnmodifiableListView<Currency> currencies;

  /// The actions that the cubit is performing.
  final UnmodifiableSetView<OwnTransferAction> actions;

  /// The actions that encountered errors.
  final UnmodifiableSetView<OwnTransferAction> errors;

  /// The API error message to be displayed.
  final String? errorMessage;

  /// The id of the transfer
  final int? transferId;

  /// The status of the submitted transfer.
  final TransferStatus? resultStatus;

  /// Device uid
  final String deviceUID;

  /// TODO: cubit_issue | Why do we need this? We already have the transfer
  /// object which has a destination account. We should only set that account
  /// to the preselected one when we fetch the accounts. This value is
  /// duplicated.
  ///
  /// The preselectedAccount for from account.
  final Account? preselectedAccount;

  /// If is edit mode or not
  ///
  /// Defaults to `false`
  final bool editMode;

  /// Creates new [OwnTransferState].
  OwnTransferState({
    required this.transfer,
    required this.editMode,
    Iterable<Account> fromAccounts = const [],
    Iterable<Account> toAccounts = const [],
    Iterable<Currency> currencies = const [],
    Set<OwnTransferAction> actions = const {},
    Set<OwnTransferAction> errors = const {},
    this.errorMessage,
    this.resultStatus,
    required this.deviceUID,
    this.transferId,
    this.preselectedAccount,
  })  : fromAccounts = UnmodifiableListView(fromAccounts),
        toAccounts = UnmodifiableListView(toAccounts),
        currencies = UnmodifiableListView(currencies),
        actions = UnmodifiableSetView(actions),
        errors = UnmodifiableSetView(errors);

  /// Creates a copy of the current state with the passed values.
  OwnTransferState copyWith({
    OwnTransfer? transfer,
    Iterable<Account>? fromAccounts,
    Iterable<Account>? toAccounts,
    Iterable<Currency>? currencies,
    Set<OwnTransferAction>? actions,
    Set<OwnTransferAction>? errors,
    bool clearErrorMessage = false,
    String? errorMessage,
    TransferStatus? resultStatus,
    int? transferId,
    Account? preselectedAccount,
    bool? editMode,
    String? deviceUID,
  }) =>
      OwnTransferState(
        transfer: transfer ?? this.transfer,
        fromAccounts: fromAccounts ?? this.fromAccounts,
        toAccounts: toAccounts ?? this.toAccounts,
        currencies: currencies ?? this.currencies,
        actions: actions ?? this.actions,
        errors: errors ?? this.errors,
        preselectedAccount: preselectedAccount ?? this.preselectedAccount,
        errorMessage:
            clearErrorMessage ? null : errorMessage ?? this.errorMessage,
        resultStatus: resultStatus ?? this.resultStatus,
        transferId: transferId ?? this.transferId,
        editMode: editMode ?? this.editMode,
        deviceUID: deviceUID ?? this.deviceUID,
      );

  /// get from accounts
  List<Account> get currentFromAccounts => fromAccounts
      .where(
        (account) => transfer.destination?.account?.id != account.id,
      )
      .toList();

  /// get to accounts
  List<Account> get currentToAccounts => toAccounts
      .where(
        (account) => transfer.source?.account?.id != account.id,
      )
      .toList();

  @override
  List<Object?> get props => [
        transfer,
        fromAccounts,
        toAccounts,
        currencies,
        actions,
        errors,
        deviceUID,
        errorMessage,
        resultStatus,
        transferId,
        preselectedAccount,
        editMode,
      ];
}
