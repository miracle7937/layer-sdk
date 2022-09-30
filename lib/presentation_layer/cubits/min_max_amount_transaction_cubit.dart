import 'package:bloc/bloc.dart';
import '../../domain_layer/use_cases/min_max_amount_transaction_use_case.dart';
import 'min_max_amount_transaction_state.dart';

/// Cubit responsible for retrieving the list of
/// customer [MinMaxTransactionAmount]
class MinMaxTransactionAmountCubit extends Cubit<MinMaxTransactionAmountState> {
  final GetMinMaxTransactionAmountUseCase
      _getCustomerMinMaxTransactionAmountUseCase;

  /// Creates a new instance of [MinMaxTransactionAmountCubit]
  MinMaxTransactionAmountCubit({
    required GetMinMaxTransactionAmountUseCase
        getCustomerMinMaxTransactionAmountUseCase,
    String? accountId,
    String? cardId,
  })  : _getCustomerMinMaxTransactionAmountUseCase =
            getCustomerMinMaxTransactionAmountUseCase,
        super(
          MinMaxTransactionAmountState(
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
        actions: state.addAction(MinMaxTransactionAmountAction.loadFilters),
        errors: state.removeErrorForAction(
          MinMaxTransactionAmountAction.loadFilters,
        ),
      ),
    );

    try {
      final filters = await _getCustomerMinMaxTransactionAmountUseCase(
        accountId: accountId ?? state.accountId,
        cardId: cardId ?? state.cardId,
      );

      emit(
        state.copyWith(
          filters: filters,
          actions: state.removeAction(
            MinMaxTransactionAmountAction.loadFilters,
          ),
          errors: state.removeErrorForAction(
            MinMaxTransactionAmountAction.loadFilters,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            MinMaxTransactionAmountAction.loadFilters,
          ),
          errors: state.addErrorFromException(
            action: MinMaxTransactionAmountAction.loadFilters,
            exception: e,
          ),
        ),
      );
    }
  }
}
