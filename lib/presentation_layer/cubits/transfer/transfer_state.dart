import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../../presentation_layer/utils.dart';
import '../../../domain_layer/models.dart';

/// The available error status
enum TransferErrorStatus {
  /// No errors
  none,

  /// Generic error
  generic,

  /// Network error
  network,
}

/// The state of the transfers cubit
class TransferState extends Equatable {
  /// The customer id of the user that this transfers belong to.
  final String customerId;

  /// A list of transfers
  final UnmodifiableListView<Transfer> transfers;

  /// True if the cubit is processing something.
  final bool busy;

  /// Has all the data needed to handle the list of transfers.
  final Pagination pagination;

  /// The current error status.
  final TransferErrorStatus errorStatus;

  /// Creates a new [TransferState].
  TransferState({
    required this.customerId,
    Iterable<Transfer> transfers = const <Transfer>[],
    this.busy = false,
    this.pagination = const Pagination(),
    this.errorStatus = TransferErrorStatus.none,
  }) : transfers = UnmodifiableListView(transfers);

  @override
  List<Object?> get props => [
        customerId,
        transfers,
        busy,
        pagination,
        errorStatus,
      ];

  /// Creates a new state based on this one.
  TransferState copyWith({
    String? customerId,
    Iterable<Transfer>? transfers,
    bool? busy,
    Pagination? pagination,
    TransferErrorStatus? errorStatus,
  }) =>
      TransferState(
        customerId: customerId ?? this.customerId,
        transfers: transfers ?? this.transfers,
        busy: busy ?? this.busy,
        pagination: pagination ?? this.pagination,
        errorStatus: errorStatus ?? this.errorStatus,
      );
}
