import 'package:bloc/bloc.dart';

import '../../../data_layer/data_layer.dart';
import 'financial_data_states.dart';

/// Cubit responsible for retrieving the financial data for a customer
class FinancialDataCubit extends Cubit<FinancialDataState> {
  final FinancialDataRepository _repository;

  /// Creates a new instance of [FinancialDataCubit]
  FinancialDataCubit({
    required String customerId,
    required FinancialDataRepository repository,
  })  : _repository = repository,
        super(
          FinancialDataState(
            customerId: customerId,
          ),
        );

  /// Loads the financial data
  Future<void> load({
    bool forceRefresh = false,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        error: FinancialDataStateErrors.none,
      ),
    );

    try {
      final data = await _repository.loadFinancialData(
        customerId: state.customerId,
        forceRefresh: forceRefresh,
      );

      emit(
        state.copyWith(
          financialData: data,
          busy: false,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          busy: false,
          error: FinancialDataStateErrors.generic,
        ),
      );

      rethrow;
    }
  }
}
