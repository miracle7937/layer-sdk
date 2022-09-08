import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain_layer/models.dart';
import '../../../utils/pagination.dart';

///  The available error status
enum MandatePaymentsErrorStatus {
  ///  No errors
  none,

  ///  Generic error
  generic,

  ///  Network error
  network,
}

/// Which loading action the cubit is doing
enum MandatePaymentsBusyAction {
  /// if loading the first time
  loading,

  /// If is loading more data
  loadingMore,
}

/// Class that contains the state for [MandatePaymentsCubit]
class MandatePaymentsState extends Equatable {
  /// If the cubit is busy
  final bool busy;

  /// Which busy action is the cubit doing
  final MandatePaymentsBusyAction busyAction;

  /// The cubit error status
  final MandatePaymentsErrorStatus errorStatus;

  /// A list of [MandatePayment]
  final UnmodifiableListView<MandatePayment> payments;

  /// Handles pagination
  final Pagination pagination;

  /// Creates a new [MandatePaymentsState]
  MandatePaymentsState({
    this.busy = false,
    this.errorStatus = MandatePaymentsErrorStatus.none,
    this.pagination = const Pagination(),
    Iterable<MandatePayment> payments = const <MandatePayment>[],
    this.busyAction = MandatePaymentsBusyAction.loading,
  }) : payments = UnmodifiableListView(payments);

  @override
  List<Object?> get props {
    return [
      busy,
      errorStatus,
      payments,
      pagination,
      busyAction,
    ];
  }

  /// Creates a copy of [MandatePaymentsState]
  MandatePaymentsState copyWith({
    bool? busy,
    MandatePaymentsErrorStatus? errorStatus,
    Iterable<MandatePayment>? payments,
    Pagination? pagination,
    MandatePaymentsBusyAction? busyAction,
  }) {
    return MandatePaymentsState(
      busy: busy ?? this.busy,
      errorStatus: errorStatus ?? this.errorStatus,
      payments: payments ?? this.payments,
      pagination: pagination ?? this.pagination,
      busyAction: busyAction ?? this.busyAction,
    );
  }
}
