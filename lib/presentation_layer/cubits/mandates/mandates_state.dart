import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';
import '../../utils/pagination.dart';

///  The available error status
enum MandatesErrorStatus {
  ///  No errors
  none,

  ///  Generic error
  generic,

  ///  Network error
  network,
}

/// Which loading action the cubit is doing
enum MandatesBusyAction {
  /// if loading the first time
  loading,

  /// If is loading more data
  loadingMore,
}

/// The state used on [MandateCubit]
class MandatesState extends Equatable {
  /// If the cubit is busy
  final bool busy;

  /// Which busy action is the cubit doing
  final MandatesBusyAction busyAction;

  /// If the cubit catched an error
  final MandatesErrorStatus errorStatus;

  /// The error message that was caught
  final String errorMessage;

  /// A List of [Mandate]
  final UnmodifiableListView<Mandate> mandates;

  /// Handle data pagination
  final Pagination pagination;

  /// Creates a new [MandateState]
  MandatesState({
    this.busy = false,
    this.errorStatus = MandatesErrorStatus.none,
    this.errorMessage = '',
    this.pagination = const Pagination(),
    Iterable<Mandate> mandates = const <Mandate>[],
    this.busyAction = MandatesBusyAction.loading,
  }) : mandates = UnmodifiableListView(mandates);

  @override
  List<Object?> get props => [
        busy,
        errorStatus,
        errorMessage,
        mandates,
        pagination,
        busyAction,
      ];

  /// Makes a copy of the current [MandatesState]
  MandatesState copyWith({
    bool? busy,
    MandatesErrorStatus? errorStatus,
    String? errorMessage,
    Iterable<Mandate>? mandates,
    Pagination? pagination,
    MandatesBusyAction? busyAction,
  }) {
    return MandatesState(
      busy: busy ?? this.busy,
      errorStatus: errorStatus ?? this.errorStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      mandates: mandates ?? this.mandates,
      pagination: pagination ?? this.pagination,
      busyAction: busyAction ?? this.busyAction,
    );
  }
}
