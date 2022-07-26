import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';
import '../../utils.dart';

/// The available error status
enum LandingTransferErrorStatus {
  /// No errors
  none,

  /// Generic error
  generic,

  /// Network error
  network,
}

/// The state for [LandingTransferCubit ]
class LandingTransferState extends Equatable {
  /// True if the cubit is processing something.
  final bool busy;

  /// The current error status.
  final LandingTransferErrorStatus error;

  /// Has all the data needed to handle the list of frequent transfers.
  final Pagination pagination;

  /// A list of frequent transfers
  final UnmodifiableListView<Transfer> frequentTransfers;

  /// A list of currecies
  final UnmodifiableListView<Currency> currencies;

  /// Creates a new [LandingTransferState] instance
  LandingTransferState({
    Iterable<Transfer> frequentTransfers = const <Transfer>[],
    Iterable<Currency> currencies = const <Currency>[],
    this.busy = false,
    this.error = LandingTransferErrorStatus.none,
    this.pagination = const Pagination(),
  })  : frequentTransfers = UnmodifiableListView(frequentTransfers),
        currencies = UnmodifiableListView(currencies);

  /// Creates a new state based on this one.
  LandingTransferState copyWith({
    bool? busy,
    LandingTransferErrorStatus? error,
    int? limit,
    Pagination? pagination,
    Iterable<Transfer>? frequentTransfers,
    Iterable<Currency>? currencies,
  }) {
    return LandingTransferState(
      busy: busy ?? this.busy,
      error: error ?? this.error,
      pagination: pagination ?? this.pagination,
      frequentTransfers: frequentTransfers ?? this.frequentTransfers,
      currencies: currencies ?? this.currencies,
    );
  }

  @override
  List<Object?> get props => [
        busy,
        error,
        pagination,
        frequentTransfers,
        currencies,
      ];
}
