import 'package:bloc/bloc.dart';

import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';
import '../../extensions.dart';

/// Cubit responsible for retrieving the list of customer [Account]
class AccountCubit extends Cubit<AccountState> {
  final GetCustomerAccountsUseCase _getCustomerAccountsUseCase;

  /// Creates a new instance of [AccountCubit]
  AccountCubit({
    required GetCustomerAccountsUseCase getCustomerAccountsUseCase,
    required String customerId,
  })  : _getCustomerAccountsUseCase = getCustomerAccountsUseCase,
        super(AccountState(customerId: customerId));

  /// Loads all accounts of the provided customer id
  ///
  /// If [forceRefresh] is true, will skip the cache.
  Future<void> load({
    bool forceRefresh = false,
    AccountFilter? filter,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        error: AccountStateErrors.none,
      ),
    );

    try {
      final accounts = await _getCustomerAccountsUseCase(
        customerId: state.customerId,
        forceRefresh: forceRefresh,
        filter: filter,
      );

      emit(
        state.copyWith(
          accounts: accounts,
          busy: false,
          error: AccountStateErrors.none,
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          busy: false,
          error: AccountStateErrors.generic,
        ),
      );
    }
  }
}
