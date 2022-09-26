import 'package:bloc/bloc.dart';

import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// Cubit responsible for retrieving the list of customer [AccountTransaction]
class AccountTransactionsCubit extends Cubit<AccountTransactionsState> {
  final GetCustomerAccountTransactionsUseCase
      _getCustomerAccountTransactionsUseCase;

  /// Maximum number of transactions to load at a time.
  final int limit;

  /// Creates a new instance of [AccountTransactionsCubit]
  AccountTransactionsCubit({
    required GetCustomerAccountTransactionsUseCase
        getCustomerAccountTransactionsUseCase,
    required String accountId,
    this.limit = 50,
  })  : _getCustomerAccountTransactionsUseCase =
            getCustomerAccountTransactionsUseCase,
        super(
          AccountTransactionsState(
            accountId: accountId,
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
      actions: state.addAction(AccountTransactionsAction.changeDate),
      errors: state.removeErrorForAction(
        AccountTransactionsAction.changeDate,
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
      actions: state.removeAction(AccountTransactionsAction.changeDate),
      errors: state.removeErrorForAction(
        AccountTransactionsAction.changeDate,
      ),
    ));
  }

  /// Loads all account completed account transactions of the provided
  Future<void> load({
    bool loadMore = false,
    bool forceRefresh = false,
    int? fromDate,
    int? toDate,
  }) async {
    emit(
      state.copyWith(
        actions: state.addAction(loadMore
            ? AccountTransactionsAction.changeDate
            : AccountTransactionsAction.loadInitialTransactionss),
        errors: state.removeErrorForAction(
          loadMore
              ? AccountTransactionsAction.changeDate
              : AccountTransactionsAction.loadInitialTransactionss,
        ),
      ),
    );

    try {
      final offset = loadMore ? state.listData.offset + limit : 0;

      final transactions = await _getCustomerAccountTransactionsUseCase(
        accountId: state.accountId,
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
                ? AccountTransactionsAction.changeDate
                : AccountTransactionsAction.loadInitialTransactionss,
          ),
          errors: state.removeErrorForAction(
            loadMore
                ? AccountTransactionsAction.changeDate
                : AccountTransactionsAction.loadInitialTransactionss,
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
                ? AccountTransactionsAction.changeDate
                : AccountTransactionsAction.loadInitialTransactionss,
          ),
          errors: state.addErrorFromException(
            action: loadMore
                ? AccountTransactionsAction.changeDate
                : AccountTransactionsAction.loadInitialTransactionss,
            exception: e,
          ),
        ),
      );
    }
  }
}
