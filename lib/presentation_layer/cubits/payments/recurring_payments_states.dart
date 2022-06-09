import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';

/// The available error status
enum RecurringPaymentErrorStatus {
  /// No errors
  none,

  /// Network error
  network,
}

/// The state of the payment cubit
class RecurringPaymentState extends Equatable {
  /// The customer id of the user that paid these payments.
  final String customerId;

  /// The list of recurring [Payment]s.
  final UnmodifiableListView<Payment> recurringPayments;

  /// True if the cubit is processing something.
  final bool busy;

  /// The current error status.
  final RecurringPaymentErrorStatus errorStatus;

  /// True if there is more payments to load
  final bool canLoadMore;

  /// The current offset
  final int offset;

  /// The number of items to load at a time.
  final int limit;

  /// Creates a new state.
  RecurringPaymentState({
    required this.customerId,
    Iterable<Payment> recurringPayments = const <Payment>[],
    this.busy = false,
    this.errorStatus = RecurringPaymentErrorStatus.none,
    this.canLoadMore = true,
    this.offset = 0,
    this.limit = 50,
  }) : recurringPayments = UnmodifiableListView(recurringPayments);

  @override
  List<Object?> get props => [
        customerId,
        recurringPayments,
        busy,
        errorStatus,
        canLoadMore,
        offset,
        limit,
      ];

  /// Creates a new state based on this one.
  RecurringPaymentState copyWith({
    String? customerId,
    Iterable<Payment>? recurringPayments,
    bool? busy,
    RecurringPaymentErrorStatus? errorStatus,
    bool? canLoadMore,
    int? offset,
    int? limit,
  }) =>
      RecurringPaymentState(
        customerId: customerId ?? this.customerId,
        recurringPayments: recurringPayments ?? this.recurringPayments,
        busy: busy ?? this.busy,
        errorStatus: errorStatus ?? this.errorStatus,
        canLoadMore: canLoadMore ?? this.canLoadMore,
        offset: offset ?? this.offset,
        limit: limit ?? this.limit,
      );
}
