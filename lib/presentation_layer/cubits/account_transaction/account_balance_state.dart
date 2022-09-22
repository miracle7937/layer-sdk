import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';

/// Represents the state of [AccountBalanceCubit]
class AccountBalanceState extends Equatable {
  /// True if the cubit is processing something
  final bool busy;

  /// List of [AccountBalance] of the customer [Account]
  final UnmodifiableListView<AccountBalance> balances;

  /// Error message for the last occurred error
  final AccountBalanceStateErrors error;

  /// [Customer] id which will be used by this cubit
  final String customerId;

  /// [Account] id which will be used by this cubit
  final String accountId;

  /// Creates a new instance of [AccountBalanceState]
  AccountBalanceState({
    required this.customerId,
    required this.accountId,
    Iterable<AccountBalance> balances = const [],
    this.busy = false,
    this.error = AccountBalanceStateErrors.none,
  }) : balances = UnmodifiableListView(balances);

  @override
  List<Object?> get props => [
        busy,
        balances,
        error,
        customerId,
        accountId,
      ];

  /// Creates a new instance of [AccountBalanceState]
  /// based on the current instance
  AccountBalanceState copyWith({
    bool? busy,
    Iterable<AccountBalance>? balances,
    AccountBalanceStateErrors? error,
    String? accountId,
    String? customerId,
  }) {
    return AccountBalanceState(
      busy: busy ?? this.busy,
      balances: balances ?? this.balances,
      error: error ?? this.error,
      customerId: customerId ?? this.customerId,
      accountId: accountId ?? this.accountId,
    );
  }

  @override
  bool get stringify => true;
}

/// Enum for all possible errors for [AccountBalanceCubit]
enum AccountBalanceStateErrors {
  /// No errors
  none,

  /// Generic error
  generic,
}
