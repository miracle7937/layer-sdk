import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../../presentation_layer/utils.dart';
import '../../../domain_layer/models.dart';

/// The available error status
enum UpcomingPaymentErrorStatus {
  /// No errors
  none,

  /// Generic error
  generic,

  /// Network error
  network,
}

///The state of the upcoming payment cubit
class UpcomingPaymentState extends Equatable {
  ///The list of [UpcomingPayment]
  final UnmodifiableListView<UpcomingPayment> upcomingPayments;

  ///The total amount of upcoming payments
  final double total;

  ///The currency of upcoming payments
  final String currency;

  /// True if the cubit is processing something.
  final bool busy;

  /// The current error status.
  final UpcomingPaymentErrorStatus errorStatus;

  /// The current error message.
  final String? errorMessage;

  /// The pagination data.
  final Pagination pagination;

  ///Creates a new state
  UpcomingPaymentState({
    Iterable<UpcomingPayment> upcomingPayments = const [],
    this.total = 0.0,
    this.currency = '',
    this.busy = false,
    this.errorStatus = UpcomingPaymentErrorStatus.none,
    this.errorMessage,
    required this.pagination,
  }) : upcomingPayments = UnmodifiableListView(upcomingPayments);

  @override
  List<Object?> get props => [
        upcomingPayments,
        total,
        currency,
        busy,
        errorStatus,
        errorMessage,
        pagination,
      ];

  /// Creates a new state based on this one.
  UpcomingPaymentState copyWith({
    Iterable<UpcomingPayment>? upcomingPayments,
    double? total,
    String? currency,
    bool? busy,
    UpcomingPaymentErrorStatus? errorStatus,
    String? errorMessage,
    Pagination? pagination,
  }) =>
      UpcomingPaymentState(
        upcomingPayments: upcomingPayments ?? this.upcomingPayments,
        total: total ?? this.total,
        currency: currency ?? this.currency,
        busy: busy ?? this.busy,
        errorStatus: errorStatus ?? this.errorStatus,
        errorMessage: errorMessage ?? this.errorMessage,
        pagination: pagination ?? this.pagination,
      );
}
