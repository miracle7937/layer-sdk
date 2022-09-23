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
    required String customerId,
    required String accountId,
    this.limit = 50,
  })  : _getCustomerAccountTransactionsUseCase =
            getCustomerAccountTransactionsUseCase,
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
    int? fromDate,
    int? toDate,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        error: AccountTransactionsStateErrors.none,
      ),
    );

    try {
      final offset = loadMore ? state.listData.offset + limit : 0;

      final transactions = await _getCustomerAccountTransactionsUseCase(
        accountId: state.accountId,
        customerId: state.customerId,
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
