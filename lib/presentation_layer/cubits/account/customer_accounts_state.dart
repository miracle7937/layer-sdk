import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';

/// Enum for all possible errors for [AccountCubit]
enum CustomerAccountStateErrors {
  /// No errors
  none,

  /// Generic error
  generic,
}

/// Represents the state of [CustomerAccountsCubit]
class CustomerAccountsState extends Equatable {
  /// True if the cubit is processing something
  final bool busy;

  /// List of [Account] of the customer
  final UnmodifiableListView<Account> accounts;

  /// Error message for the last occurred error
  final CustomerAccountStateErrors error;

  /// Creates a new instance of [CustomerAccountsState]
  CustomerAccountsState({
    Iterable<Account> accounts = const [],
    this.busy = false,
    this.error = CustomerAccountStateErrors.none,
  }) : accounts = UnmodifiableListView(accounts);

  /// Creates a new instance of [CustomerAccountsState] based on
  /// the current instance.
  CustomerAccountsState copyWith({
    bool? busy,
    Iterable<Account>? accounts,
    CustomerAccountStateErrors? error,
  }) {
    return CustomerAccountsState(
      busy: busy ?? this.busy,
      accounts: accounts ?? this.accounts,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        busy,
        accounts,
        error,
      ];
}
