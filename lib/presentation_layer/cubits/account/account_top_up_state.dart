import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';

/// Represents all possible actions of the [AccountTopUpCubit].
enum AccountTopUpActions {
  /// No actions being performed.
  none,

  /// The top up request is being sent.
  toppingUpAccount,

  /// The cubit is busy requesting a new secret key for the Stripe SDK.
  requestingSecret,

  /// The cubit is busy requesting the image receipt of the top up.
  requestingImageReceipt,

  /// The cubit is busy requesting the pdf receipt of the top up.
  requestingPdfReceipt,
}

/// Represents all available errors of the [AccountTopUpCubit].
enum AccountTopUpErrors {
  /// No error being thrown
  none,

  /// Failed to top up the account.
  failedToTopUpAccount,

  /// Failed to request a new Stripe SDK secret key.
  failedToRequestSecret,

  /// Failed to request the top up receipt.
  failedToRequestReceipt,
}

/// Holds the [AccountTopUpCubit] state.
class AccountTopUpState extends Equatable {
  /// The customer's account used in the top up.
  final Account? account;

  /// The amount that will be topped up.
  final double amount;

  /// The current action being performed.
  final AccountTopUpActions action;

  /// The current error
  final AccountTopUpErrors error;

  /// The actual Stripe SDK secret used to make payments.
  final String? secret;

  /// The image receipt in a list of bytes.
  final UnmodifiableListView<int>? imageReceipt;

  /// The pdf receipt in a list of bytes.
  final UnmodifiableListView<int>? pdfReceipt;

  /// The ID of the top up.
  final String? topUpId;

  /// Creates a new [AccountTopUpState] instance.
  AccountTopUpState({
    this.account,
    this.action = AccountTopUpActions.none,
    this.error = AccountTopUpErrors.none,
    this.amount = 0.0,
    this.secret,
    this.topUpId,
    Iterable<int>? imageReceiptBytes,
    Iterable<int>? pdfReceiptBytes,
  })  : imageReceipt = imageReceiptBytes != null
            ? UnmodifiableListView(imageReceiptBytes)
            : null,
        pdfReceipt = pdfReceiptBytes != null
            ? UnmodifiableListView(pdfReceiptBytes)
            : null;

  /// Creates a new [AccountTopUpState] with the provided parameters.
  AccountTopUpState copyWith({
    Account? account,
    double? amount,
    AccountTopUpActions? action,
    AccountTopUpErrors? error,
    bool clearSecret = false,
    String? secret,
    Iterable<int>? imageReceipt,
    Iterable<int>? pdfReceipt,
    String? topUpId,
  }) {
    return AccountTopUpState(
      account: account ?? this.account,
      amount: amount ?? this.amount,
      action: action ?? this.action,
      error: error ?? this.error,
      secret: clearSecret ? null : secret ?? this.secret,
      imageReceiptBytes: imageReceipt ?? this.imageReceipt,
      pdfReceiptBytes: pdfReceipt ?? this.pdfReceipt,
      topUpId: topUpId ?? this.topUpId,
    );
  }

  @override
  List<Object?> get props => [
        account,
        action,
        error,
        amount,
        secret,
        imageReceipt,
        pdfReceipt,
        topUpId,
      ];
}
