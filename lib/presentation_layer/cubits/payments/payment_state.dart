import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';

/// The available error status
enum PaymentErrorStatus {
  /// No errors
  none,

  /// Generic error
  generic,

  /// Network error
  network,
}

/// The state of the payment cubit
class PaymentState extends Equatable {
  /// The customer id of the user that paid these payments.
  final String customerId;

  /// A list of [Payment].
  final UnmodifiableListView<Payment> payments;

  /// True if the cubit is processing something.
  final bool busy;

  /// The current error status.
  final PaymentErrorStatus errorStatus;

  /// True if there is more payments to load
  final bool canLoadMore;

  /// The current offset
  final int offset;

  /// The number of items to load at a time.
  final int limit;

  /// Creates a new state.
  PaymentState({
    required this.customerId,
    Iterable<Payment> payments = const <Payment>[],
    this.busy = false,
    this.errorStatus = PaymentErrorStatus.none,
    this.canLoadMore = true,
    this.offset = 0,
    this.limit = 50,
  }) : payments = UnmodifiableListView(payments);

  @override
  List<Object?> get props => [
        customerId,
        payments,
        busy,
        errorStatus,
        canLoadMore,
        offset,
        limit,
      ];

  /// Creates a new state based on this one.
  PaymentState copyWith({
    String? customerId,
    Iterable<Payment>? payments,
    bool? busy,
    PaymentErrorStatus? errorStatus,
    bool? canLoadMore,
    int? offset,
    int? limit,
  }) =>
      PaymentState(
        customerId: customerId ?? this.customerId,
        payments: payments ?? this.payments,
        busy: busy ?? this.busy,
        errorStatus: errorStatus ?? this.errorStatus,
        canLoadMore: canLoadMore ?? this.canLoadMore,
        offset: offset ?? this.offset,
        limit: limit ?? this.limit,
      );
}
