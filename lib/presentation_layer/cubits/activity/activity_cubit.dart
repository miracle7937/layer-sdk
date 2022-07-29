import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data_layer/network.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';
import '../../utils.dart';

/// A cubit that handles the [User] activities
class ActivityCubit extends Cubit<ActivityState> {
  final LoadActivitiesUseCase _loadActivitiesUseCase;

  /// Creates a new [ActivityCubit] instance
  ActivityCubit({
    required LoadActivitiesUseCase loadActivitiesUseCase,
    int limit = 20,
  })  : _loadActivitiesUseCase = loadActivitiesUseCase,
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
}
