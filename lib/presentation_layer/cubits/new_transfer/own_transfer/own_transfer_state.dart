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
  shortcut
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

  /// The image receipt belongs transfer
  final UnmodifiableListView<int> imageReceipt;

  /// The pdf receipt belongs transfer
  final UnmodifiableListView<int> pdfReceipt;

  /// The preselectedAccount for from account.
  final Account? preselectedAccount;

  /// Creates new [OwnTransferState].
  OwnTransferState({
    required this.transfer,
    Iterable<Account> fromAccounts = const [],
    Iterable<Account> toAccounts = const [],
    Iterable<Currency> currencies = const [],
    Set<OwnTransferAction> actions = const {},
    Set<OwnTransferAction> errors = const {},
    Iterable<int> pdfReceipt = const <int>[],
    Iterable<int> imageReceipt = const <int>[],
    this.errorMessage,
    this.resultStatus,
    this.transferId,
    this.preselectedAccount,
  })  : fromAccounts = UnmodifiableListView(fromAccounts),
        toAccounts = UnmodifiableListView(toAccounts),
        currencies = UnmodifiableListView(currencies),
        actions = UnmodifiableSetView(actions),
        errors = UnmodifiableSetView(errors),
        imageReceipt = UnmodifiableListView(imageReceipt),
        pdfReceipt = UnmodifiableListView(pdfReceipt);

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
    Iterable<int>? pdfReceipt,
    Iterable<int>? imageReceipt,
    int? transferId,
    Account? preselectedAccount,
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
        imageReceipt: imageReceipt ?? this.imageReceipt,
        transferId: transferId ?? this.transferId,
        pdfReceipt: pdfReceipt ?? this.pdfReceipt,
      );

  @override
  List<Object?> get props => [
        transfer,
        fromAccounts,
        toAccounts,
        currencies,
        actions,
        errors,
        errorMessage,
        resultStatus,
        transferId,
        imageReceipt,
        pdfReceipt,
        preselectedAccount,
      ];
}
