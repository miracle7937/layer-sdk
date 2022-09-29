import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain_layer/models.dart';
import '../../../../domain_layer/use_cases.dart';
import 'accounts_state.dart';

/// A Cubit that handles the state for the accounts list flow.
class AccountsCubit extends Cubit<AccountsState> {
  final LoadFinancialDataUseCase _loadFinancialDataUseCase;
  final GetCustomerAccountsUseCase _getCustomerAccountsUseCase;

  /// Creates a new [AccountsCubit].
  AccountsCubit({
    bool editMode = false,
    required LoadFinancialDataUseCase loadFinancialDataUseCase,
    required GetCustomerAccountsUseCase getCustomerAccountsUseCase,
  })  : _loadFinancialDataUseCase = loadFinancialDataUseCase,
        _getCustomerAccountsUseCase = getCustomerAccountsUseCase,
        super(
          AccountsState(),
        );

  /// Initializes the [AccountsCubit].
  Future<void> initialize() async {
    await Future.wait([
      _loadFinancialData(),
      _loadAccounts(),
    ]);
  }

  /// Loads the financial data.
  Future<void> _loadFinancialData({
    bool forceRefresh = false,
    String? customerId,
  }) async {
    emit(
      state.copyWith(
        actions: state.addAction(
          AccountsAction.financialData,
        ),
        errors: state.removeErrorForAction(
          AccountsAction.financialData,
        ),
      ),
    );

    try {
      final data = await _loadFinancialDataUseCase(
        customerId: customerId,
        forceRefresh: forceRefresh,
      );

      emit(
        state.copyWith(
          actions: state.removeAction(AccountsAction.financialData),
          financialData: data,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(AccountsAction.financialData),
          errors: state.addErrorFromException(
            action: AccountsAction.financialData,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Loads the accounts.
  Future<void> _loadAccounts({
    AccountFilter? filter,
    bool forceRefresh = false,
  }) async {
    emit(
      state.copyWith(
        actions: state.addAction(
          AccountsAction.accounts,
        ),
        errors: state.removeErrorForAction(
          AccountsAction.accounts,
        ),
      ),
    );

    try {
      final accounts = await _getCustomerAccountsUseCase(
        forceRefresh: forceRefresh,
        filter: filter,
      );

      emit(
        state.copyWith(
          actions: state.removeAction(
            AccountsAction.accounts,
          ),
          accounts: accounts,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            AccountsAction.accounts,
          ),
          errors: state.addErrorFromException(
            action: AccountsAction.accounts,
            exception: e,
          ),
        ),
      );
    }
  }
}
