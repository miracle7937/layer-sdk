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
}

/// Represents all available errors of the [AccountTopUpCubit].
enum AccountTopUpErrors {
  /// No error being thrown
  none,

  /// Failed to top up the account.
  failedToTopUpAccount,

  /// Failed to request a new Stripe SDK secret key.
  failedToRequestSecret,
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

  /// Creates a new [AccountTopUpState] instance.
  AccountTopUpState({
    this.account,
    this.action = AccountTopUpActions.none,
    this.error = AccountTopUpErrors.none,
    this.amount = 0.0,
    this.secret,
  });

  /// Creates a new [AccountTopUpState] with the provided parameters.
  AccountTopUpState copyWith({
    Account? account,
    AccountTopUpActions? action,
    AccountTopUpErrors? error,
    double? amount,
    String? secret,
    bool? clearSecret,
  }) {
    return AccountTopUpState(
      account: account ?? this.account,
      action: action ?? this.action,
      error: error ?? this.error,
      amount: amount ?? this.amount,
      secret: (clearSecret ?? false) ? null : secret ?? this.secret,
    );
  }

  @override
  List<Object?> get props => [
        account,
        action,
        error,
        amount,
        secret,
      ];
}
