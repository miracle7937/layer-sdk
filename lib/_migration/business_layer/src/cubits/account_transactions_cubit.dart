import 'package:bloc/bloc.dart';

import '../../../data_layer/data_layer.dart';
import 'account_transactions_states.dart';

/// Cubit responsible for retrieving the list of customer [AccountTransaction]
class AccountTransactionsCubit extends Cubit<AccountTransactionsState> {
  final AccountRepository _repository;

  /// Maximum number of transactions to load at a time.
  final int limit;

  /// Creates a new instance of [AccountTransactionsCubit]
  AccountTransactionsCubit({
    required AccountRepository repository,
    required customerId,
    required accountId,
    this.limit = 50,
  })  : _repository = repository,
        super(
          AccountTransactionsState(
            accountId: accountId,
            customerId: customerId,
          ),
        );

  /// Loads all account completed account transactions of the provided
  /// Customer Id and Account Id
  Future<void> load({
    bool loadMore = false,
    bool forceRefresh = false,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        error: AccountTransactionsStateErrors.none,
      ),
    );

    try {
      final offset = loadMore ? state.listData.offset + limit : 0;

      final transactions = await _repository.listCustomerAccountTransactions(
        accountId: state.accountId,
        customerId: state.customerId,
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
          busy: false,
          listData: state.listData.copyWith(
            canLoadMore: transactions.length >= limit,
            offset: offset,
          ),
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          busy: false,
          error: AccountTransactionsStateErrors.generic,
        ),
      );
    }
  }
}
