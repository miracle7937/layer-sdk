import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../../presentation_layer/utils.dart';
import '../../../domain_layer/models.dart';

/// The available errors
enum StandingOrdersError {
  /// No errors
  none,

  /// Generic error
  generic,

  /// Network error
  network,
}

/// The state of the standing orders cubit
class StandingOrdersState extends Equatable {
  /// The customer id of the user who owns these standing orders.
  final String customerId;

  /// A list of standing orders
  final UnmodifiableListView<StandingOrder> orders;

  /// True if the cubit is processing something.
  final bool busy;

  /// Holds the data for the pagination.
  final Pagination pagination;

  /// The current error status.
  final StandingOrdersError error;

  /// Creates a new [StandingOrdersState].
  StandingOrdersState({
    required this.customerId,
    Iterable<StandingOrder> orders = const <StandingOrder>[],
    this.busy = false,
    this.pagination = const Pagination(),
    this.error = StandingOrdersError.none,
  }) : orders = UnmodifiableListView(orders);

  @override
  List<Object?> get props => [
        customerId,
        orders,
        busy,
        pagination,
        error,
      ];

  /// Creates a new state based on this one.
  StandingOrdersState copyWith({
    String? customerId,
    Iterable<StandingOrder>? orders,
    bool? busy,
    Pagination? pagination,
    StandingOrdersError? error,
  }) =>
      StandingOrdersState(
        customerId: customerId ?? this.customerId,
        orders: orders ?? this.orders,
        busy: busy ?? this.busy,
        pagination: pagination ?? this.pagination,
        error: error ?? this.error,
      );
}
