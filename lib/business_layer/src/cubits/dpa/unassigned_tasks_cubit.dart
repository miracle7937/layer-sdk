import 'package:bloc/bloc.dart';

import 'package:logging/logging.dart';

import '../../../../data_layer/data_layer.dart';
import '../../../business_layer.dart';

/// A cubit that manages a list of unassigned tasks, allowing the user
/// to claim one or more for herself/himself.
class UnassignedTasksCubit extends Cubit<UnassignedTasksState> {
  final _log = Logger('UnassignedTasksCubit');

  final DPARepository _repository;

  /// Creates a new cubit using the supplied [DPARepository].
  UnassignedTasksCubit({
    required DPARepository repository,
    String? customerId,
  })  : _repository = repository,
        super(UnassignedTasksState(customerId: customerId));

  /// Loads all the unassigned tasks available.
  ///
  /// If [forceRefresh] is true, will skip the cache.
  Future<void> load({
    bool forceRefresh = false,
  }) async {
    _log.info('Load. Forcing refresh? $forceRefresh');

    emit(
      state.copyWith(
        busy: true,
        action: UnassignedTasksAction.none,
        errorStatus: UnassignedTasksErrorStatus.none,
      ),
    );

    try {
      final tasks = await _repository.listUnassignedTasks(
        forceRefresh: forceRefresh,
        customerId: state.customerId,
      );

      emit(
        state.copyWith(
          tasks: tasks,
          busy: false,
        ),
      );
    } on NetException {
      emit(
        state.copyWith(
          busy: false,
          errorStatus: UnassignedTasksErrorStatus.network,
        ),
      );
    }
  }

  /// Claims a list of unassigned tasks for the current logged-in user.
  Future<void> claimTasks({
    required List<String> tasksIds,
  }) async {
    _log.info('Claiming tasks ids: $tasksIds');

    emit(
      state.copyWith(
        busy: true,
        action: UnassignedTasksAction.none,
        errorStatus: UnassignedTasksErrorStatus.none,
      ),
    );

    final taskList = List.of(state.tasks);
    UnassignedTasksErrorStatus? error;

    var claimedATask = false;

    try {
      // Run sequentially
      for (var id in tasksIds) {
        if (await _repository.claimTask(taskId: id)) {
          taskList.removeWhere((e) => e.id == id);

          claimedATask = true;
        }
      }
    } on NetException {
      error = UnassignedTasksErrorStatus.network;
    }

    emit(
      state.copyWith(
        tasks: taskList,
        busy: false,
        action: claimedATask
            ? UnassignedTasksAction.claimed
            : UnassignedTasksAction.none,
        errorStatus: error,
      ),
    );
  }
}
