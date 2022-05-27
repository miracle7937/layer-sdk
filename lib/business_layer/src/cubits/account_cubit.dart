import 'package:bloc/bloc.dart';

import '../../../data_layer/data_layer.dart';
import 'account_states.dart';

/// Cubit responsible for retrieving the list of customer [Account]
class AccountCubit extends Cubit<AccountState> {
  final AccountRepository _repository;

  /// Creates a new instance of [AccountCubit]
  AccountCubit({
    required AccountRepository repository,
    required String customerId,
  })  : _repository = repository,
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
      final accounts = await _repository.listCustomerAccounts(
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
    } on Exception {
      emit(
        state.copyWith(
          busy: false,
          error: AccountStateErrors.generic,
        ),
      );
    }
  }
}
