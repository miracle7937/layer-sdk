import 'package:bloc/bloc.dart';

import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// Cubit responsible for retrieving the list of customer [Account]
class CustomerAccountsCubit extends Cubit<CustomerAccountsState> {
  final GetCustomerAccountsUseCase _getCustomerAccountsUseCase;

  /// Creates a new instance of [CustomerAccountsCubit]
  CustomerAccountsCubit({
    required GetCustomerAccountsUseCase getCustomerAccountsUseCase,
  })  : _getCustomerAccountsUseCase = getCustomerAccountsUseCase,
        super(CustomerAccountsState());

  /// Loads all accounts of the customer
  ///
  /// Use the [filter] parameter for filtering purposes.
  ///
  /// If [forceRefresh] is true, will skip the cache.
  Future<void> load({
    AccountFilter? filter,
    bool forceRefresh = false,
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
