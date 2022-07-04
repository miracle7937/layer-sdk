import 'package:bloc/bloc.dart';

import '../../../../../../data_layer/network.dart';
import '../../../../presentation_layer/utils.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// A cubit that keeps the list of customer standing orders.
class StandingOrdersCubit extends Cubit<StandingOrdersState> {
  final LoadStandingOrdersUseCase _loadStandingOrdersUseCase;

  /// Creates a new cubit using the supplied [StandingOrderRepository].
  StandingOrdersCubit({
    required String customerId,
    required LoadStandingOrdersUseCase loadStandingOrdersUseCase,
    int limit = 50,
  })  : _loadStandingOrdersUseCase = loadStandingOrdersUseCase,
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

      final list = await _loadStandingOrdersUseCase(
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