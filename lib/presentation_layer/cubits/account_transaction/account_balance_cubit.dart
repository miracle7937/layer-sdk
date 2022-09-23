import 'package:bloc/bloc.dart';
import '../../../domain_layer/use_cases/account_transaction/get_customer_account_balance_use_case.dart';
import 'account_balance_state.dart';

/// Cubit responsible for retrieving the list of customer [AccountTransaction]
class AccountBalanceCubit extends Cubit<AccountBalanceState> {
  final GetCustomerAccountBalanceUseCase _getCustomerAccountBalanceUseCase;

  /// Creates a new instance of [AccountBalanceCubit]
  AccountBalanceCubit({
    required GetCustomerAccountBalanceUseCase getCustomerAccountBalanceUseCase,
    required String customerId,
    required String accountId,
    required DateTime startDate,
    required DateTime endDate,
  })  : _getCustomerAccountBalanceUseCase = getCustomerAccountBalanceUseCase,
        super(
          AccountBalanceState(
            accountId: accountId,
            customerId: customerId,
            startDate: startDate,
            endDate: endDate,
          ),
        );

  ///
  Future<void> updateDates({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    emit(state.copyWith(startDate: startDate, endDate: endDate));
    load(
      customerId: state.customerId,
      accountId: state.accountId,
      interval: "day",
      loadMore: true,
    );
  }

  /// Loads all account completed account balances of the provided
  /// Customer Id and Account Id
  Future<void> load({
    required String customerId,
    required String accountId,
    required String? interval,
    bool loadMore = false,
  }) async {
    try {
      if (loadMore) {
        emit(
          state.copyWith(
            actions: state.addAction(AccountBalanceAction.changeDate),
            errors: state.removeErrorForAction(
              AccountBalanceAction.changeDate,
            ),
          ),
        );
      }
      final balances = await _getCustomerAccountBalanceUseCase(
        toDate: state.endDate.millisecondsSinceEpoch,
        fromDate: state.startDate.millisecondsSinceEpoch,
        interval: interval,
        customerId: customerId,
        accountId: accountId,
      );

      final list = balances;
      if (loadMore) {
        emit(
          state.copyWith(
            actions: state.removeAction(AccountBalanceAction.changeDate),
            errors: state.removeErrorForAction(
              AccountBalanceAction.changeDate,
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            balances: list,
            actions:
                state.removeAction(AccountBalanceAction.loadInitialBalances),
            errors: state.removeErrorForAction(
              AccountBalanceAction.loadInitialBalances,
            ),
          ),
        );
      }
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
