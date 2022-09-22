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
  })  : _getCustomerAccountBalanceUseCase = getCustomerAccountBalanceUseCase,
        super(
          AccountBalanceState(
            accountId: accountId,
            customerId: customerId,
          ),
        );

  /// Loads all account completed account balances of the provided
  /// Customer Id and Account Id
  Future<void> load({
    bool loadMore = false,
    bool forceRefresh = false,
  }) async {
    try {
      final balances = await _getCustomerAccountBalanceUseCase(
        toDate: 1632300992000,
        fromDate: 1663836992000,
        interval: 'day',
        customerId: '62da6415-5244-44fe-8e3c-b6ba7d747f6b',
        accountId: 'a15cd2103c6472bcf78ef0ab7d765a9596b25c77',
      );

      final list = balances;

      emit(
        state.copyWith(
          balances: list,
          busy: false,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          busy: false,
          error: AccountBalanceStateErrors.generic,
        ),
      );
    }
  }
}
