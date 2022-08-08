import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data_layer/network.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';
import '../../utils.dart';

/// A cubit that handles the [User] activities
class ActivityCubit extends Cubit<ActivityState> {
  final LoadActivitiesUseCase _loadActivitiesUseCase;
  final DeleteActivityUseCase _deleteActivityUseCase;
  final CancelActivityUseCase _cancelActivityUseCase;
  final CreateShortcutUseCase _createShortcutUseCase;

  /// Creates a new [ActivityCubit] instance
  ActivityCubit({
    required LoadActivitiesUseCase loadActivitiesUseCase,
    required DeleteActivityUseCase deleteActivityUseCase,
    required CancelActivityUseCase cancelActivityUseCase,
    required CreateShortcutUseCase createShortcutUseCase,
    int limit = 20,
  })  : _loadActivitiesUseCase = loadActivitiesUseCase,
        _deleteActivityUseCase = deleteActivityUseCase,
        _cancelActivityUseCase = cancelActivityUseCase,
        _createShortcutUseCase = createShortcutUseCase,
        super(ActivityState(
          pagination: Pagination(limit: limit),
        ));

  /// Loads all the activities
  Future<void> load({
    bool loadMore = false,
    bool itemIsNull = false,
    DateTime? startDate,
    DateTime? endDate,
    List<ActivityType>? types,
    List<ActivityTag>? activityTags,
    List<TransferType>? transferTypes,
  }) async {
    emit(
      state.copyWith(
        errorStatus: ActivityErrorStatus.none,
        action: loadMore
            ? ActivityBusyAction.loadingMore
            : ActivityBusyAction.loading,
      ),
    );

    try {
      final newPage = state.pagination.paginate(loadMore: loadMore);

      final resultList = await _loadActivitiesUseCase(
        limit: newPage.limit,
        offset: newPage.offset,
        fromTS: startDate,
        toTS: endDate,
        itemIsNull: itemIsNull,
        types: types,
        activityTags: activityTags,
        transferTypes: transferTypes,
      );

      final activities = newPage.firstPage
          ? resultList
          : [
              ...state.activities,
              ...resultList,
            ];

      emit(
        state.copyWith(
          activities: activities,
          action: ActivityBusyAction.none,
          pagination: newPage.refreshCanLoadMore(
            loadedCount: resultList.length,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          errorStatus: e is NetException
              ? ActivityErrorStatus.network
              : ActivityErrorStatus.generic,
          action: ActivityBusyAction.none,
        ),
      );

      rethrow;
    }
  }

  /// Delete a certain activity based on the id
  Future<void> delete(String activityId) => _deleteActivityUseCase(activityId);

  /// Cancel the [Activity] by `id`
  Future<void> cancel(String id, {String? otpValue}) => _cancelActivityUseCase(
        id,
        otpValue: otpValue,
      );

  /// Add the activity to shorcut
  Future<void> shortcut({required NewShortcut newShortcut}) =>
      _createShortcutUseCase(
        shortcut: newShortcut,
      );

  /// Save the shortcut name
  void onShortcutNameChanged(String shortcutName) => emit(
        state.copyWith(
          shortcutName: shortcutName,
        ),
      );
}
