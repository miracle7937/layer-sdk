import 'package:bloc/bloc.dart';

import '../../domain_layer/models/banking_product_transaction.dart';
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
        assert(((cardId != null) && (accountId == null)) ||
            ((cardId == null) && (accountId != null))),
        super(
          BankingProductTransactionsState(
            accountId: accountId,
            cardId: cardId,
          ),
        );

  /// Updating the dates and loading again
  Future<void> updateDates({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    emit(state.copyWith(
      cardId: state.cardId,
      accountId: state.accountId,
      startDate: startDate,
      endDate: endDate,
    ));
  }

  /// Reset the state
  Future<void> reset() async {
    emit(BankingProductTransactionsState(
      accountId: state.accountId,
      cardId: state.cardId,
    ));
  }

  /// Loads all account completed account transactions of the provided
  Future<void> load({
    bool changeDate = false,
    bool forceRefresh = false,
    DateTime? fromDate,
    DateTime? toDate,
    String? cardId,
    String? accountId,
    String? searchString,
    bool? credit,
    double? amountFrom,
    double? amountTo,
    bool loadMore = false,
  }) async {
    emit(
      state.copyWith(
        cardId: cardId ?? state.cardId,
        accountId: accountId ?? state.accountId,
        startDate: fromDate,
        endDate: toDate,
        amountFrom: amountFrom ?? state.amountFrom,
        amountTo: amountTo ?? state.amountTo,
        listData: BankingProductTransactionsListData(),
        credit: credit ?? state.credit,
        actions: state.addAction(loadMore
            ? BankingProductTransactionsAction.loadingMore
            : (changeDate
                ? BankingProductTransactionsAction.filtering
                : BankingProductTransactionsAction.loadInitialTransactions)),
        errors: state.removeValidationError(
          changeDate
              ? BankingProductTransactionsErrorCode.filterError
              : BankingProductTransactionsErrorCode.loadError,
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

      // ignore: omit_local_variable_types
      final List<BankingProductTransaction> list = offset > 0
          ? [
              ...state.transactions?.take(offset).toList() ?? [],
              ...transactions
            ]
          : transactions;
      emit(
        state.copyWith(
          transactions: list,
          actions: state.removeAction(
            loadMore
                ? BankingProductTransactionsAction.loadingMore
                : changeDate
                    ? BankingProductTransactionsAction.filtering
                    : BankingProductTransactionsAction.loadInitialTransactions,
          ),
          errors: state.removeValidationError(
            changeDate
                ? BankingProductTransactionsErrorCode.filterError
                : BankingProductTransactionsErrorCode.loadError,
          ),
          listData: state.listData.copyWith(
            canLoadMore: transactions.length >= limit,
            offset: offset,
          ),
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          actions: state.removeAction(
            changeDate
                ? BankingProductTransactionsAction.filtering
                : BankingProductTransactionsAction.loadInitialTransactions,
          ),
          errors: state.addValidationError(
            validationErrorCode: changeDate
                ? BankingProductTransactionsErrorCode.filterError
                : BankingProductTransactionsErrorCode.loadError,
          ),
        ),
      );
    }
  }
}
