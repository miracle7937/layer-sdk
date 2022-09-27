import 'package:bloc/bloc.dart';
import '../../../domain_layer/use_cases/account_transaction/get_customer_account_balance_use_case.dart';
import 'account_balance_state.dart';

/// Cubit responsible for retrieving the list of customer [AccountTransaction]
class AccountBalanceCubit extends Cubit<AccountBalanceState> {
  final GetCustomerAccountBalanceUseCase _getCustomerAccountBalanceUseCase;

  /// Creates a new instance of [AccountBalanceCubit]
  AccountBalanceCubit({
    required GetCustomerAccountBalanceUseCase getCustomerAccountBalanceUseCase,
    required String accountId,
    required DateTime startDate,
    required DateTime endDate,
  })  : _getCustomerAccountBalanceUseCase = getCustomerAccountBalanceUseCase,
        super(
          AccountBalanceState(
            accountId: accountId,
            startDate: startDate,
            endDate: endDate,
          ),
        );

  /// Updating the dates and loading again for different weeks
  Future<void> updateDates({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    load(
      accountId: state.accountId,
      interval: "day",
      loadMore: true,
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// Loads all account completed account balances of the provided
  /// Customer Id and Account Id
  Future<void> load({
    required String accountId,
    required String? interval,
    bool loadMore = false,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      emit(
        state.copyWith(
          startDate: startDate,
          endDate: endDate,
          actions: state.addAction(loadMore
              ? AccountBalanceAction.changeDate
              : AccountBalanceAction.loadInitialBalances),
          errors: state.removeErrorForAction(
            loadMore
                ? AccountBalanceAction.changeDate
                : AccountBalanceAction.loadInitialBalances,
          ),
        ),
      );
      final balances = await _getCustomerAccountBalanceUseCase(
        toDate: state.endDate.millisecondsSinceEpoch,
        fromDate: state.startDate.millisecondsSinceEpoch,
        interval: interval,
        accountId: accountId,
      );

      emit(
        state.copyWith(
          balances: balances,
          actions: state.removeAction(
            loadMore
                ? AccountBalanceAction.changeDate
                : AccountBalanceAction.loadInitialBalances,
          ),
          errors: state.removeErrorForAction(
            loadMore
                ? AccountBalanceAction.changeDate
                : AccountBalanceAction.loadInitialBalances,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            loadMore
                ? AccountBalanceAction.changeDate
                : AccountBalanceAction.loadInitialBalances,
          ),
          errors: state.addErrorFromException(
            action: loadMore
                ? AccountBalanceAction.changeDate
                : AccountBalanceAction.loadInitialBalances,
            exception: e,
          ),
        ),
      );
    }
  }
}
