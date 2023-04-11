import 'package:bloc/bloc.dart';

import '../../../../data_layer/network.dart';
import '../../../../layer_sdk.dart';

/// Cubit responsible for retrieving [LoyaltyPointsTransfer].
class LoyaltyPointsTransactionCubit
    extends Cubit<LoyaltyPointsTransactionState> {
  final LoadLoyaltyPointsTransactionsByTypeUseCase
      _loadLoyaltyPointsTransactionsByTypeUseCase;
  final LoyaltyPointsTransactionType? _type;

  /// Creates a new [LoyaltyPointsTransactionCubit] using
  /// the supplied [LoadLoyaltyPointsTransactionsUseCase].
  LoyaltyPointsTransactionCubit({
    required LoadLoyaltyPointsTransactionsByTypeUseCase
        loadLoyaltyPointsTransactionsByTypeUseCase,
    LoyaltyPointsTransactionType? type,
    bool loadMore = false,
  })  : _loadLoyaltyPointsTransactionsByTypeUseCase =
            loadLoyaltyPointsTransactionsByTypeUseCase,
        _type = type,
        super(LoyaltyPointsTransactionState());

  /// Load loyalty transactions
  Future<void> load({
    bool loadMore = false,
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    emit(
      state.copyWith(
        busy: loadMore ? null : true,
        loadingMore: loadMore ? true : null,
        errorStatus: LoyaltyPointsTransactionErrorStatus.none,
      ),
    );

    try {
      final pagination = state.pagination.paginate(loadMore: loadMore);

      emit(state.copyWith(
        pagination: pagination,
      ));

      final newTransactions = await _loadLoyaltyPointsTransactionsByTypeUseCase(
        transactionType: _type,
        limit: pagination.limit,
        offset: pagination.offset,
        searchQuery: searchQuery,
        startDate: startDate,
        endDate: endDate,
      );

      final transations = pagination.firstPage
          ? newTransactions
          : [
              ...state.transactions,
              ...newTransactions,
            ];

      emit(
        state.copyWith(
          transactions: transations,
          busy: false,
          loadingMore: false,
          pagination: pagination.refreshCanLoadMore(
            loadedCount: newTransactions.length,
          ),
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          errorStatus: e is NetException
              ? LoyaltyPointsTransactionErrorStatus.network
              : LoyaltyPointsTransactionErrorStatus.generic,
          busy: false,
          loadingMore: false,
        ),
      );

      rethrow;
    }
  }
}
