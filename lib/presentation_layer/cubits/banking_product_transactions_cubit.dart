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
    emit(state.copyWith(
      startDate: startDate,
      endDate: endDate,
      actions: state.addAction(BankingProductTransactionsAction.changeDate),
      errors: state.removeErrorForAction(
        BankingProductTransactionsAction.changeDate,
      ),
    ));
    load(
      fromDate: startDate.millisecondsSinceEpoch,
      toDate: endDate.millisecondsSinceEpoch,
      loadMore: true,
    );
    emit(state.copyWith(
      startDate: startDate,
      endDate: endDate,
      actions: state.removeAction(BankingProductTransactionsAction.changeDate),
      errors: state.removeErrorForAction(
        BankingProductTransactionsAction.changeDate,
      ),
    ));
  }

  /// Loads all account completed account transactions of the provided
  Future<void> load({
    bool loadMore = false,
    bool forceRefresh = false,
    int? fromDate,
    int? toDate,
    String? cardId,
    String? accountId,
  }) async {
    emit(
      state.copyWith(
        actions: state.addAction(loadMore
            ? BankingProductTransactionsAction.changeDate
            : BankingProductTransactionsAction.loadInitialTransactionss),
        errors: state.removeErrorForAction(
          loadMore
              ? BankingProductTransactionsAction.changeDate
              : BankingProductTransactionsAction.loadInitialTransactionss,
        ),
      ),
    );

    try {
      final offset = loadMore ? state.listData.offset + limit : 0;

      final transactions = await _getCustomerBankingProductTransactionsUseCase(
        accountId: accountId ?? state.accountId,
        cardId: cardId ?? state.cardId,
        fromDate: fromDate,
        toDate: toDate,
        offset: offset,
        limit: limit,
        forceRefresh: forceRefresh,
      );

      final list = offset > 0
          ? [...state.transactions.take(offset).toList(), ...transactions]
          : transactions;

      emit(
        state.copyWith(
          transactions: list,
          actions: state.removeAction(
            loadMore
                ? BankingProductTransactionsAction.changeDate
                : BankingProductTransactionsAction.loadInitialTransactionss,
          ),
          errors: state.removeErrorForAction(
            loadMore
                ? BankingProductTransactionsAction.changeDate
                : BankingProductTransactionsAction.loadInitialTransactionss,
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
                ? BankingProductTransactionsAction.changeDate
                : BankingProductTransactionsAction.loadInitialTransactionss,
          ),
          errors: state.addErrorFromException(
            action: loadMore
                ? BankingProductTransactionsAction.changeDate
                : BankingProductTransactionsAction.loadInitialTransactionss,
            exception: e,
          ),
        ),
      );
    }
  }
}
