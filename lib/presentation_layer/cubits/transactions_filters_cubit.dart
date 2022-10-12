import 'package:bloc/bloc.dart';
import '../../domain_layer/use_cases/transactions_filters_use_case.dart';
import 'transactions_filters_state.dart';

/// Cubit responsible for retrieving the list of
/// customer [TransactionFilters]
class TransactionFiltersCubit extends Cubit<TransactionFiltersState> {
  final GetTransactionFiltersUseCase _getCustomerTransactionFiltersUseCase;

  /// Creates a new instance of [TransactionFiltersCubit]
  TransactionFiltersCubit({
    required GetTransactionFiltersUseCase getCustomerTransactionFiltersUseCase,
    String? accountId,
    String? cardId,
  })  : _getCustomerTransactionFiltersUseCase =
            getCustomerTransactionFiltersUseCase,
        assert(((cardId != null) && (accountId == null)) ||
            ((cardId == null) && (accountId != null))),
        super(
          TransactionFiltersState(
            accountId: accountId,
            cardId: cardId,
          ),
        );

  ///
  Future<void> load({
    String? cardId,
    String? accountId,
  }) async {
    emit(
      state.copyWith(
        cardId: cardId ?? state.cardId,
        accountId: accountId ?? state.accountId,
        actions: state.addAction(TransactionFiltersAction.loadFilters),
        errors: state.removeErrorForAction(
          TransactionFiltersAction.loadFilters,
        ),
      ),
    );

    try {
      final filters = await _getCustomerTransactionFiltersUseCase(
        accountId: accountId ?? state.accountId,
        cardId: cardId ?? state.cardId,
      );

      emit(
        state.copyWith(
          filters: filters,
          actions: state.removeAction(
            TransactionFiltersAction.loadFilters,
          ),
          errors: state.removeErrorForAction(
            TransactionFiltersAction.loadFilters,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            TransactionFiltersAction.loadFilters,
          ),
          errors: state.addErrorFromException(
            action: TransactionFiltersAction.loadFilters,
            exception: e,
          ),
        ),
      );
    }
  }
}
