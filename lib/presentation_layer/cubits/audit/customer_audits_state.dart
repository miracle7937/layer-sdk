import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';

///The state of the customer audits  cubit
class CustomerAuditsState extends Equatable {
  /// The customer id who has the audits.
  final String customerId;

  /// True if the cubit is processing something.
  final bool busy;

  /// The list of audits.
  final UnmodifiableListView<Audit> audits;

  /// The current error.
  final CustomerAuditsStateError error;

  /// The currrent limit for the loaded list.
  final int limit;

  /// The current offset for the loaded list.
  final int offset;

  /// If there is more data to be loaded.
  final bool canLoadMore;

  /// The field to use to sort the data.
  final AuditSort sortBy;

  /// If field should be sorted in descending order.
  final bool descendingOrder;

  /// Creates a new [CustomerAuditsState]
  CustomerAuditsState({
    required this.customerId,
    Iterable<Audit> audits = const [],
    this.busy = false,
    this.error = CustomerAuditsStateError.none,
    this.limit = 50,
    this.offset = 0,
    this.canLoadMore = true,
    this.sortBy = AuditSort.date,
    this.descendingOrder = true,
  }) : audits = UnmodifiableListView(audits);

  @override
  List<Object?> get props => [
        customerId,
        audits,
        busy,
        error,
        limit,
        offset,
        canLoadMore,
        sortBy,
        descendingOrder,
      ];

  /// Creates a new state based on this one
  CustomerAuditsState copyWith({
    String? customerId,
    Iterable<Audit>? audits,
    bool? busy,
    CustomerAuditsStateError? error,
    int? offset,
    bool? canLoadMore,
    AuditSort? sortBy,
    bool? descendingOrder,
  }) =>
      CustomerAuditsState(
        customerId: customerId ?? this.customerId,
        audits: audits ?? this.audits,
        busy: busy ?? this.busy,
        error: error ?? this.error,
        limit: limit,
        offset: offset ?? this.offset,
        canLoadMore: canLoadMore ?? this.canLoadMore,
        sortBy: sortBy ?? this.sortBy,
        descendingOrder: descendingOrder ?? this.descendingOrder,
      );
}

/// All possible errors for [CustomerAuditsState]
enum CustomerAuditsStateError {
  /// No errors
  none,

  /// Generic error
  generic,
}
