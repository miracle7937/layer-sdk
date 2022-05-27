import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../data_layer/data_layer.dart';

/// Represents the state of [AccountCubit]
class AccountState extends Equatable {
  /// True if the cubit is processing something
  final bool busy;

  /// List of [Account] of the customer
  final UnmodifiableListView<Account> accounts;

  /// Error message for the last occurred error
  final AccountStateErrors error;

  /// [Customer] id which will be used by this cubit
  final String customerId;

  /// Creates a new instance of [AccountState]
  AccountState({
    required this.customerId,
    Iterable<Account> accounts = const [],
    this.busy = false,
    this.error = AccountStateErrors.none,
  }) : accounts = UnmodifiableListView(accounts);

  @override
  List<Object?> get props => [
        busy,
        accounts,
        error,
        customerId,
      ];

  /// Creates a new instance of [AccountState] based on the current instance
  AccountState copyWith({
    bool? busy,
    Iterable<Account>? accounts,
    AccountStateErrors? error,
    String? customerId,
  }) {
    return AccountState(
      busy: busy ?? this.busy,
      accounts: accounts ?? this.accounts,
      customerId: customerId ?? this.customerId,
      error: error ?? this.error,
    );
  }
}

/// Enum for all possible errors for [AccountCubit]
enum AccountStateErrors {
  /// No errors
  none,

  /// Generic error
  generic,
}
