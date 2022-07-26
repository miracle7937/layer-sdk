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

/// Class that contains the state for [MandatePaymentsCubit]
class MandatePaymentsState extends Equatable {
  /// If the cubit is busy
  final bool busy;

  /// The possible error message
  final String errorMessage;

  /// The cubit error status
  final MandatePaymentsErrorStatus errorStatus;

  /// A list of [MandatePayment]
  final UnmodifiableListView<MandatePayment> payments;

  /// Handles pagination
  final Pagination pagination;

  /// Creates a new [MandatePaymentsState]
  MandatePaymentsState({
    this.busy = false,
    this.errorMessage = '',
    this.errorStatus = MandatePaymentsErrorStatus.none,
    this.pagination = const Pagination(limit: 20),
    Iterable<MandatePayment> payments = const <MandatePayment>[],
  }) : payments = UnmodifiableListView(payments);

  @override
  List<Object?> get props {
    return [
      busy,
      errorMessage,
      errorStatus,
      payments,
      pagination,
    ];
  }

  /// Creates a copy of [MandatePaymentsState]
  MandatePaymentsState copyWith({
    bool? busy,
    String? errorMessage,
    MandatePaymentsErrorStatus? errorStatus,
    Iterable<MandatePayment>? payments,
    Pagination? pagination,
  }) {
    return MandatePaymentsState(
      busy: busy ?? this.busy,
      errorMessage: errorMessage ?? this.errorMessage,
      errorStatus: errorStatus ?? this.errorStatus,
      payments: payments ?? this.payments,
      pagination: pagination ?? this.pagination,
    );
  }
}
