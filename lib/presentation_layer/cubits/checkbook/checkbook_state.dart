import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';

/// The state of the customer checkbooks cubit
class CheckbookState extends Equatable {
  /// The customer ID that has these checkbooks
  final String customerId;

  /// List of [Checkbook] of the customer
  final UnmodifiableListView<Checkbook> checkbooks;

  /// If the cubit is processing something
  final bool busy;

  /// The current error
  final CheckbookStateError error;

  /// The current limit
  final int limit;

  /// The current offset
  final int offset;

  /// If more checkbooks can be loaded
  final bool canLoadMore;

  /// If field should be sorted in descending order.
  final bool descendingOrder;

  /// The current sorting field
  final CheckbookSort? sortBy;

  /// Creates a new [CheckbookState]
  CheckbookState({
    required this.customerId,
    Iterable<Checkbook> checkbooks = const [],
    this.busy = false,
    this.error = CheckbookStateError.none,
    this.limit = 50,
    this.offset = 0,
    this.canLoadMore = true,
    this.descendingOrder = true,
    this.sortBy,
  }) : checkbooks = UnmodifiableListView(checkbooks);

  @override
  List<Object?> get props => [
        customerId,
        checkbooks,
        busy,
        error,
        limit,
        offset,
        canLoadMore,
        descendingOrder,
        sortBy,
      ];

  /// Creates a new instance of [CheckbookState] based on the current instance
  CheckbookState copyWith({
    String? customerId,
    Iterable<Checkbook>? checkbooks,
    bool? busy,
    CheckbookStateError? error,
    int? offset,
    bool? canLoadMore,
    bool? descendingOrder,
    CheckbookSort? sortBy,
  }) =>
      CheckbookState(
        customerId: customerId ?? this.customerId,
        checkbooks: checkbooks ?? this.checkbooks,
        busy: busy ?? this.busy,
        limit: limit,
        error: error ?? this.error,
        offset: offset ?? this.offset,
        canLoadMore: canLoadMore ?? this.canLoadMore,
        descendingOrder: descendingOrder ?? this.descendingOrder,
        sortBy: sortBy ?? this.sortBy,
      );
}

/// All possible errors for [CheckbookState]
enum CheckbookStateError {
  /// No errors
  none,

  /// Generic error
  generic,
}
