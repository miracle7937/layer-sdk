import 'package:bloc/bloc.dart';
import 'package:logging/logging.dart';

import '../../../../../data_layer/network.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';
import '../../extensions.dart';

/// A cubit that manages a list of tasks associated with the current user.
class UserTasksCubit extends Cubit<UserTasksState> {
  final _log = Logger('UserTasksCubit');

  final ListUserTasksUseCase _userTasksUseCase;
  final FinishTaskUseCase _finishTaskUseCase;

  /// Creates a new cubit using the supplied [DPARepository].
  ///
  /// Optionally, you can pass a customerId to only list the tasks associated
  /// with that customer.
  UserTasksCubit({
    required ListUserTasksUseCase userTasksUseCase,
    required FinishTaskUseCase finishTaskUseCase,
    String? customerId,
  })  : _userTasksUseCase = userTasksUseCase,
        _finishTaskUseCase = finishTaskUseCase,
        super(
          UserTasksState(customerId: customerId),
        );

  /// Loads all the tasks available for this user.
  ///
  /// If [forceRefresh] is true, will skip the cache.
  Future<void> load({
    bool forceRefresh = false,
  }) async {
    _log.info('Load. Forcing refresh? $forceRefresh');

    emit(
      state.copyWith(
        busy: true,
        errorStatus: UserTasksErrorStatus.none,
        action: UserTasksAction.none,
      ),
    );

    try {
      final tasks = await _userTasksUseCase(
        customerId: state.customerId,
        fetchCustomersData: state.customerId == null,
        forceRefresh: forceRefresh,
      );

      emit(
        state.copyWith(
          tasks: tasks,
          busy: false,
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          busy: false,
          errorStatus: UserTasksErrorStatus.network,
        ),
      );

      rethrow;
    }
  }

  /// Finalizes the given [Task] with the given decision.
  ///
  /// If successful, emits the list of tasks without the finalized task.
  Future<void> finalize({
    required DPATask task,
    required String decision,
  }) async {
    assert(decision.isNotEmpty);

    _log.info('Finalizing task ${task.id}. Decision: $decision.');

    emit(
      state.copyWith(
        busy: true,
        errorStatus: UserTasksErrorStatus.none,
        action: UserTasksAction.none,
      ),
    );

    try {
      final success = await _finishTaskUseCase(
        task: task.copyWith(
          variables: task.variables.map(
            (e) => e.id.toLowerCase() == 'decision'
                ? e.copyWith(value: decision)
                : e,
          ),
        ),
      );

      emit(
        state.copyWith(
          tasks: success ? state.tasks.where((e) => e.id != task.id) : null,
          busy: false,
          action: success ? UserTasksAction.finalizedTask : null,
          errorStatus: !success ? UserTasksErrorStatus.network : null,
        ),
      );
    } on NetException catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          busy: false,
          errorStatus: UserTasksErrorStatus.network,
        ),
      );
    }
  }
}
