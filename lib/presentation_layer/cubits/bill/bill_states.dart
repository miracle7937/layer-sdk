import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';

/// The available error status
enum BillsErrorStatus {
  /// No errors
  none,

  /// Generic error
  generic,

  /// Network error
  network,
}

/// The state of the bill cubit
class BillState extends Equatable {
  /// The customer id of the user that paid these bills.
  final String customerId;

  /// A list of [Bill].
  final UnmodifiableListView<Bill> bills;

  /// True if the cubit is processing something.
  final bool busy;

  /// True if there is more bills to load
  final bool canLoadMore;

  /// The current error status.
  final BillsErrorStatus errorStatus;

  /// The current offset
  final int offset;

  /// Creates a new state.
  BillState({
    required this.customerId,
    Iterable<Bill> bills = const <Bill>[],
    this.busy = false,
    this.canLoadMore = true,
    this.offset = 0,
    this.errorStatus = BillsErrorStatus.none,
  }) : bills = UnmodifiableListView(bills);

  @override
  List<Object?> get props => [
        customerId,
        bills,
        busy,
        canLoadMore,
        offset,
        errorStatus,
      ];

  /// Creates a new state based on this one.
  BillState copyWith({
    String? customerId,
    Iterable<Bill>? bills,
    int? offset,
    bool? busy,
    bool? canLoadMore,
    BillsErrorStatus? errorStatus,
  }) =>
      BillState(
        customerId: customerId ?? this.customerId,
        bills: bills ?? this.bills,
        offset: offset ?? this.offset,
        busy: busy ?? this.busy,
        canLoadMore: canLoadMore ?? this.canLoadMore,
        errorStatus: errorStatus ?? this.errorStatus,
      );
}
