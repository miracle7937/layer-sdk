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

  /// [Customer] id which will be used by this cubit. Can be null.
  final String? customerId;

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

  /// Whether or not the state values should be hidden.
  ///
  /// Defaults to `false`.
  final bool hideValues;

  ///Creates a new state
  UpcomingPaymentState({
    Iterable<UpcomingPayment> upcomingPayments = const [],
    this.customerId,
    this.total = 0.0,
    this.currency = '',
    this.busy = false,
    this.errorStatus = UpcomingPaymentErrorStatus.none,
    this.errorMessage,
    this.hideValues = false,
    required this.pagination,
  }) : upcomingPayments = UnmodifiableListView(upcomingPayments);

  @override
  List<Object?> get props => [
        upcomingPayments,
        customerId,
        total,
        currency,
        busy,
        errorStatus,
        errorMessage,
        pagination,
        hideValues,
      ];

  /// Creates a new state based on this one.
  UpcomingPaymentState copyWith({
    Iterable<UpcomingPayment>? upcomingPayments,
    String? customerId,
    double? total,
    String? currency,
    bool? busy,
    UpcomingPaymentErrorStatus? errorStatus,
    String? errorMessage,
    Pagination? pagination,
    bool? hideValues,
  }) =>
      UpcomingPaymentState(
        upcomingPayments: upcomingPayments ?? this.upcomingPayments,
        customerId: customerId ?? this.customerId,
        total: total ?? this.total,
        currency: currency ?? this.currency,
        busy: busy ?? this.busy,
        errorStatus: errorStatus ?? this.errorStatus,
        errorMessage: errorMessage ?? this.errorMessage,
        pagination: pagination ?? this.pagination,
        hideValues: hideValues ?? this.hideValues,
      );
}
