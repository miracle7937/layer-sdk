import 'package:bloc/bloc.dart';

import '../../../data_layer/data_layer.dart';
import 'branch_states.dart';

/// Cubit responsible for the branches' data.
class BranchCubit extends Cubit<BranchState> {
  final BranchRepository _repository;

  /// Creates a new instance of [BranchCubit]
  BranchCubit({
    required BranchRepository repository,
  })  : _repository = repository,
        super(
          BranchState(),
        );

  /// Loads all available branches
  Future<void> load({
    bool forceRefresh = false,
  }) async {
    emit(
      state.copyWith(
        actions: state.actions.union({BranchBusyAction.load}),
        error: BranchStateError.none,
      ),
    );

    try {
      final branches = await _repository.list(
        forceRefresh: forceRefresh,
      );

      emit(
        state.copyWith(
          branches: branches,
          actions: state.actions.difference({
            BranchBusyAction.load,
          }),
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          actions: state.actions.difference({
            BranchBusyAction.load,
          }),
          error: BranchStateError.generic,
        ),
      );

      rethrow;
    }
  }
}
