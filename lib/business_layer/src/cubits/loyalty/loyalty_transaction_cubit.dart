import 'package:bloc/bloc.dart';
import '../../../../data_layer/data_layer.dart';
import 'loyalty_transactions_states.dart';

/// Cubit responsible for retrieving [LoyaltyTransfer]
class LoyaltyTransactionCubit extends Cubit<LoyaltyTransactionState> {
  final LoyaltyPointsRepository _repository;
  final LoyaltyTransactionType _type;

  /// Creates a new cubit using the supplied [LoyaltyPointsRepository].
  LoyaltyTransactionCubit({
    required LoyaltyPointsRepository repository,
    required LoyaltyTransactionType type,
    bool loadMore = false,
  })  : _repository = repository,
        _type = type,
        super(LoyaltyTransactionState());

  /// Load loyalty transactions
  Future<void> load({
    bool loadMore = false,
    String? searchQuery,
  }) async {
    emit(
      state.copyWith(
        busy: loadMore ? null : true,
        loadingMore: loadMore ? true : null,
        errorStatus: LoyaltyTransactionErrorStatus.none,
      ),
    );

    try {
      final pagination = state.pagination.paginate(loadMore: loadMore);

      emit(state.copyWith(
        pagination: pagination,
      ));

      final newTransactions = await _repository.listTransactions(
        transactionType: _type,
        limit: pagination.limit,
        offset: pagination.offset,
        searchQuery: searchQuery,
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
    } on Exception catch (e) {
      emit(
        state.copyWith(
          errorStatus: e is NetException
              ? LoyaltyTransactionErrorStatus.network
              : LoyaltyTransactionErrorStatus.generic,
          busy: false,
          loadingMore: false,
        ),
      );

      rethrow;
    }
  }
}
