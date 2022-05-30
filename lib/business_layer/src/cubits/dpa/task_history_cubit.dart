import 'package:bloc/bloc.dart';

import 'package:logging/logging.dart';

import '../../../../data_layer/data_layer.dart';
import '../../../business_layer.dart';

/// A cubit that manages the history of closed tasks.
class TaskHistoryCubit extends Cubit<TaskHistoryState> {
  final _log = Logger('TaskHistoryCubit');

  final DPARepository _repository;

  /// Creates a new cubit using the supplied [DPARepository].
  TaskHistoryCubit({
    required DPARepository repository,
  })  : _repository = repository,
        super(TaskHistoryState());

  /// Loads all the tasks history.
  ///
  /// If [forceRefresh] is true, will skip the cache.
  Future<void> load({
    bool forceRefresh = false,
  }) async {
    _log.info('Load. Forcing refresh? $forceRefresh');

    emit(
      state.copyWith(
        busy: true,
        errorStatus: TaskHistoryErrorStatus.none,
      ),
    );

    try {
      final tasks = await _repository.listHistory(
        forceRefresh: forceRefresh,
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
          errorStatus: TaskHistoryErrorStatus.network,
        ),
      );
    }
  }
}
