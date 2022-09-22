import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';
import '../../utils/pagination.dart';

/// The available error status
enum FrequentPaymentsErrorStatus {
  /// No errors
  none,

  /// Generic error
  generic,

  /// Network error
  network,
}

/// Which loading action the cubit is doing
enum FrequentPaymentsBusyAction {
  /// if loading the first time
  loading,

  /// If is loading more data
  loadingMore,
}

/// The state of the [FrequentPayment] cubit
class FrequentPaymentsState extends Equatable {
  /// A list of [Payment].
  final UnmodifiableListView<Payment> payments;

  /// True if the cubit is processing something.
  final bool busy;

  /// Which busy action is the cubit doing
  final FrequentPaymentsBusyAction busyAction;

  /// The current error status.
  final FrequentPaymentsErrorStatus errorStatus;

  /// Handles transaction pagination
  final Pagination pagination;

  /// Creates a new state.
  FrequentPaymentsState({
    Iterable<Payment> payments = const <Payment>[],
    this.busy = false,
    this.errorStatus = FrequentPaymentsErrorStatus.none,
    this.busyAction = FrequentPaymentsBusyAction.loading,
    this.pagination = const Pagination(),
  }) : payments = UnmodifiableListView(payments);

  @override
  List<Object?> get props => [
        payments,
        busy,
        errorStatus,
        busyAction,
        pagination,
      ];

  /// Creates a new state based on this one.
  FrequentPaymentsState copyWith({
    Iterable<Payment>? payments,
    bool? busy,
    FrequentPaymentsErrorStatus? errorStatus,
    Pagination? pagination,
    FrequentPaymentsBusyAction? busyAction,
  }) =>
      FrequentPaymentsState(
        payments: payments ?? this.payments,
        busy: busy ?? this.busy,
        errorStatus: errorStatus ?? this.errorStatus,
        pagination: pagination ?? this.pagination,
        busyAction: busyAction ?? this.busyAction,
      );
}
