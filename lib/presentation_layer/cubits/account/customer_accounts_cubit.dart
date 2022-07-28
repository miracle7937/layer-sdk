import 'package:bloc/bloc.dart';

import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// Cubit responsible for retrieving the list of customer [Account]
class CustomerAccountsCubit extends Cubit<CustomerAccountsState> {
  final GetCustomerAccountsUseCase _getCustomerAccountsUseCase;

  /// Creates a new instance of [AccountCubit]
  CustomerAccountsCubit({
    required GetCustomerAccountsUseCase getCustomerAccountsUseCase,
  })  : _getCustomerAccountsUseCase = getCustomerAccountsUseCase,
        super(CustomerAccountsState());

  /// Loads all accounts of the customer
  ///
  /// If [forceRefresh] is true, will skip the cache.
  Future<void> load({
    bool forceRefresh = false,
    AccountFilter? filter,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        error: CustomerAccountStateErrors.none,
      ),
    );

    try {
      final accounts = await _getCustomerAccountsUseCase(
        forceRefresh: forceRefresh,
        filter: filter,
      );

      emit(
        state.copyWith(
          accounts: accounts,
          busy: false,
          error: CustomerAccountStateErrors.none,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          busy: false,
          error: CustomerAccountStateErrors.generic,
        ),
      );
    }
  }
}
