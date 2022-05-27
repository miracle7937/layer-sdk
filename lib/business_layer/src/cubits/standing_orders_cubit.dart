import 'package:bloc/bloc.dart';

import '../../../data_layer/data_layer.dart';
import '../cubits.dart';
import '../utils.dart';

/// A cubit that keeps the list of customer standing orders.
class StandingOrdersCubit extends Cubit<StandingOrdersState> {
  final StandingOrderRepository _repository;

  /// Creates a new cubit using the supplied [StandingOrderRepository].
  StandingOrdersCubit({
    required StandingOrderRepository repository,
    required String customerId,
    int limit = 50,
  })  : _repository = repository,
        super(
          StandingOrdersState(
            customerId: customerId,
            pagination: Pagination(limit: limit),
          ),
        );

  /// Loads a list of standing orders.
  ///
  /// If [loadMore] is true, will try to update the list with more data.
  Future<void> load({
    bool loadMore = false,
    bool includeDetails = true,
    bool forceRefresh = false,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        error: StandingOrdersError.none,
      ),
    );

    try {
      final newPage = state.pagination.paginate(loadMore: loadMore);

      final list = await _repository.list(
        customerId: state.customerId,
        offset: newPage.offset,
        limit: newPage.limit,
        includeDetails: includeDetails,
        forceRefresh: forceRefresh,
      );

      final orders = newPage.firstPage
          ? list
          : [
              ...state.orders.take(newPage.offset).toList(),
              ...list,
            ];

      emit(
        state.copyWith(
          orders: orders,
          busy: false,
          pagination: newPage.refreshCanLoadMore(
            loadedCount: list.length,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          error: e is NetException
              ? StandingOrdersError.network
              : StandingOrdersError.generic,
          busy: false,
        ),
      );

      rethrow;
    }
  }
}
