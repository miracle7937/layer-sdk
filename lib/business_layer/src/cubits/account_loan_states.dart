import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../data_layer/data_layer.dart';

/// All possible errors for [AccountLoanState]
enum AccountLoanStateErrors {
  /// No errors
  none,

  /// Generic error
  generic,
}

/// Represents the state of [AccountLoanCubit]
class AccountLoanState extends Equatable {
  /// The customer id to be used by this cubit.
  ///
  /// Can be null. In that case, you can use the cubit to get loans
  /// by account ids, for instance.
  final String? customerId;

  /// The list of loans done by the supplied customer
  final UnmodifiableListView<AccountLoan> loans;

  /// Whether or not this cubit is busy
  final bool busy;

  /// Whether or not there's data left to load
  final bool canLoadMore;

  /// How many items to load at a time.
  final int limit;

  /// The current pagination offset
  final int offset;

  /// The last occurred error
  final AccountLoanStateErrors error;

  /// Creates a new instance of [AccountLoanState]
  AccountLoanState({
    this.customerId,
    Iterable<AccountLoan> loans = const [],
    this.busy = false,
    this.canLoadMore = false,
    this.limit = 50,
    this.offset = 0,
    this.error = AccountLoanStateErrors.none,
  }) : loans = UnmodifiableListView(loans);

  @override
  List<Object?> get props => [
        customerId,
        loans,
        busy,
        canLoadMore,
        limit,
        offset,
        error,
      ];

  /// Creates a new instance of [AccountLoanState] based on the current instance
  AccountLoanState copyWith({
    String? customerId,
    Iterable<AccountLoan>? loans,
    bool? busy,
    bool? canLoadMore,
    int? limit,
    int? offset,
    AccountLoanStateErrors? error,
  }) =>
      AccountLoanState(
        customerId: customerId ?? this.customerId,
        loans: loans ?? this.loans,
        busy: busy ?? this.busy,
        canLoadMore: canLoadMore ?? this.canLoadMore,
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        error: error ?? this.error,
      );
}
