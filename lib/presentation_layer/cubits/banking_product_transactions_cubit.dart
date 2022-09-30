import 'package:bloc/bloc.dart';

import '../../domain_layer/use_cases/banking_product_transactions_use_case.dart';
import 'banking_product_transactions_state.dart';

/// Cubit responsible for retrieving the list of
/// customer [BankingProductTransaction]
class BankingProductTransactionsCubit
    extends Cubit<BankingProductTransactionsState> {
  final GetCustomerBankingProductTransactionsUseCase
      _getCustomerBankingProductTransactionsUseCase;

  /// Maximum number of transactions to load at a time.
  final int limit;

  /// Creates a new instance of [BankingProductTransactionsCubit]
  BankingProductTransactionsCubit({
    required GetCustomerBankingProductTransactionsUseCase
        getCustomerBankingProductTransactionsUseCase,
    String? accountId,
    String? cardId,
    this.limit = 50,
  })  : _getCustomerBankingProductTransactionsUseCase =
            getCustomerBankingProductTransactionsUseCase,
        super(
          BankingProductTransactionsState(
            accountId: accountId,
            cardId: cardId,
          ),
        );

  /// Updating the dates and loading again
  Future<void> updateDates({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    load(
      fromDate: startDate,
      toDate: endDate,
      loadMore: true,
    );
  }

  /// Reset the state
  Future<void> reset() async {
    emit(BankingProductTransactionsState(
      accountId: state.accountId,
      cardId: state.cardId,
    ));
    await load(
      accountId: state.accountId,
      cardId: state.cardId,
    );
  }

  /// Loads all account completed account transactions of the provided
  Future<void> load({
    bool loadMore = false,
    bool forceRefresh = false,
    DateTime? fromDate,
    DateTime? toDate,
    String? cardId,
    String? accountId,
    String? searchString,
    bool? credit,
    double? amountFrom,
    double? amountTo,
  }) async {
    emit(
      state.copyWith(
        cardId: cardId ?? state.cardId,
        accountId: accountId ?? state.accountId,
        startDate: fromDate,
        endDate: toDate,
        amountFrom: amountFrom,
        amountTo: amountTo,
        credit: credit,
        actions: state.addAction(state.listData.canLoadMore
            ? BankingProductTransactionsAction.loadingMore
            : (loadMore
                ? BankingProductTransactionsAction.filtering
                : BankingProductTransactionsAction.loadInitialTransactions)),
        errors: state.removeErrorForAction(
          loadMore
              ? BankingProductTransactionsAction.filtering
              : BankingProductTransactionsAction.loadInitialTransactions,
        ),
      ),
    );

    try {
      final offset = loadMore ? state.listData.offset + limit : 0;
      final transactions = await _getCustomerBankingProductTransactionsUseCase(
        accountId: accountId ?? state.accountId,
        cardId: cardId ?? state.cardId,
        startDate: fromDate ?? state.startDate,
        endDate: toDate ?? state.endDate,
        offset: offset,
        limit: limit,
        forceRefresh: forceRefresh,
        searchString: searchString,
        credit: credit ?? state.credit,
        amountFrom: amountFrom ?? state.amountFrom,
        amountTo: amountTo ?? state.amountTo,
      );

      final list = offset > 0
          ? [...state.transactions.take(offset).toList(), ...transactions]
          : transactions;

      emit(
        state.copyWith(
          transactions: list,
          actions: state.removeAction(
            state.listData.canLoadMore
                ? BankingProductTransactionsAction.loadingMore
                : loadMore
                    ? BankingProductTransactionsAction.filtering
                    : BankingProductTransactionsAction.loadInitialTransactions,
          ),
          errors: state.removeErrorForAction(
            loadMore
                ? BankingProductTransactionsAction.filtering
                : BankingProductTransactionsAction.loadInitialTransactions,
          ),
          listData: state.listData.copyWith(
            canLoadMore: transactions.length >= limit,
            offset: offset,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            loadMore
                ? BankingProductTransactionsAction.filtering
                : BankingProductTransactionsAction.loadInitialTransactions,
          ),
          errors: state.addErrorFromException(
            action: loadMore
                ? BankingProductTransactionsAction.filtering
                : BankingProductTransactionsAction.loadInitialTransactions,
            exception: e,
          ),
        ),
      );
    }
  }
}
