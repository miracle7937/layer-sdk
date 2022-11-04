import 'package:collection/collection.dart';

import '../../../domain_layer/models.dart';
import '../../utils.dart';
import '../base_cubit/base_state.dart';

/// Enum for the actions
enum LandingTransferAction {
  /// Loading frequent transfers
  loading,
}

/// The state for [LandingTransferCubit ]
class LandingTransferState
    extends BaseState<LandingTransferAction, void, void> {
  /// Has all the data needed to handle the list of frequent transfers.
  final Pagination pagination;

  /// A list of frequent transfers
  final UnmodifiableListView<Transfer> frequentTransfers;

  /// Creates a new [LandingTransferState] instance
  LandingTransferState({
    this.pagination = const Pagination(),
    Iterable<Transfer> frequentTransfers = const <Transfer>[],
    super.actions = const <LandingTransferAction>{},
    super.errors = const <CubitError>{},
  }) : frequentTransfers = UnmodifiableListView(frequentTransfers);

  /// Creates a new state based on this one.
  LandingTransferState copyWith({
    Pagination? pagination,
    Iterable<Transfer>? frequentTransfers,
    Set<LandingTransferAction>? actions,
    Set<CubitError>? errors,
  }) {
    return LandingTransferState(
      pagination: pagination ?? this.pagination,
      frequentTransfers: frequentTransfers ?? this.frequentTransfers,
      actions: actions ?? super.actions,
      errors: errors ?? super.errors,
    );
  }

  @override
  List<Object?> get props => [
        pagination,
        frequentTransfers,
        actions,
        errors,
        events,
      ];
}
