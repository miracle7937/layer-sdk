import 'package:bloc/bloc.dart';
import 'package:logging/logging.dart';

import '../../../data_layer/network.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';
import '../../extensions.dart';

/// A cubit that manages the history of closed tasks.
class TaskHistoryCubit extends Cubit<TaskHistoryState> {
  final _log = Logger('TaskHistoryCubit');

  final LoadDPAHistoryUseCase _dpaHistoryUseCase;

  /// Creates a new cubit using the supplied [LoadDPAHistoryUseCase].
  TaskHistoryCubit({
    required LoadDPAHistoryUseCase dpaHistoryUseCase,
  })  : _dpaHistoryUseCase = dpaHistoryUseCase,
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
      final tasks = await _dpaHistoryUseCase(
        forceRefresh: forceRefresh,
      );

      emit(
        state.copyWith(
          tasks: tasks,
          busy: false,
        ),
      );
    } on NetException catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          busy: false,
          errorStatus: TaskHistoryErrorStatus.network,
        ),
      );
    }
  }
}
