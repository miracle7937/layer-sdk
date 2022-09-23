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
    // required DateTime startDate,
    // required DateTime endDate,
  })  : _getCustomerAccountBalanceUseCase = getCustomerAccountBalanceUseCase,
        super(
          AccountBalanceState(
            accountId: accountId,
            customerId: customerId,
            startDate: DateTime.now(),
            endDate: DateTime.now(),
          ),
        );

  /// Loads all account completed account balances of the provided
  /// Customer Id and Account Id
  Future<void> load({
    required String customerId,
    required String accountId,
    required int? fromDate,
    required int? toDate,
    required String? interval,
  }) async {
    try {
      final balances = await _getCustomerAccountBalanceUseCase(
        toDate: toDate,
        fromDate: fromDate,
        interval: interval,
        customerId: customerId,
        accountId: accountId,
      );

      final list = balances;

      emit(
        state.copyWith(
          balances: list,
          actions: state.removeAction(AccountBalanceAction.loadInitialBalances),
          errors: state.removeErrorForAction(
            AccountBalanceAction.loadInitialBalances,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(AccountBalanceAction.loadInitialBalances),
          errors: state.addErrorFromException(
            action: AccountBalanceAction.loadInitialBalances,
            exception: e,
          ),
        ),
      );
    }
  }
}
