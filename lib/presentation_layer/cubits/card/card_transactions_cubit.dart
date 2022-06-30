import 'package:bloc/bloc.dart';

import '../../../domain_layer/use_cases/card/load_customer_card_transactions_use_case.dart';
import 'card_transactions_states.dart';

/// Cubit responsible for retrieving the list of customer [CardTransaction]
class CardTransactionsCubit extends Cubit<CardTransactionsState> {
  final LoadCustomerCardTransactionsUseCase _getCustomerCardTransactionsUseCase;

  /// Creates a new instance of [CardTransactionsCubit]
  CardTransactionsCubit({
    required LoadCustomerCardTransactionsUseCase
        getCustomerCardTransactionsUseCase,
    required String customerId,
    required String cardId,
    int limit = 50,
  })  : _getCustomerCardTransactionsUseCase =
            getCustomerCardTransactionsUseCase,
        super(
          CardTransactionsState(
            customerId: customerId,
            cardId: cardId,
            listData: CardTransactionsListData(
              limit: limit,
            ),
          ),
        );

  /// Loads all Card completed Card transactions of the
  /// previously provided [Customer] Id and [Card] Id
  Future<void> load({
    bool loadMore = false,
    bool forceRefresh = false,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        error: CardTransactionsStateErrors.none,
      ),
    );

    try {
      final offset =
          loadMore ? state.listData.offset + state.listData.limit : 0;

      final transactions = await _getCustomerCardTransactionsUseCase(
        cardId: state.cardId,
        customerId: state.customerId,
        limit: state.listData.limit,
        offset: offset,
        forceRefresh: forceRefresh,
      );

      final list = offset > 0
          ? [...state.transactions.take(offset).toList(), ...transactions]
          : transactions;

      emit(
        state.copyWith(
          transactions: list,
          busy: false,
          listData: state.listData.copyWith(
            canLoadMore: transactions.length >= state.listData.limit,
            offset: offset,
          ),
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          busy: false,
          error: CardTransactionsStateErrors.generic,
        ),
      );

      rethrow;
    }
  }
}
