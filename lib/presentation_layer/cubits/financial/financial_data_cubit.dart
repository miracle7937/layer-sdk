import 'package:bloc/bloc.dart';

import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';
import '../../extensions.dart';

/// Cubit responsible for retrieving the financial data for a customer
class FinancialDataCubit extends Cubit<FinancialDataState> {
  final LoadFinancialDataUseCase _loadFinancialDataUseCase;

  /// Creates a new instance of [FinancialDataCubit]
  FinancialDataCubit({
     String? customerId,
    required LoadFinancialDataUseCase loadFinancialDataUseCase,
  })  : _loadFinancialDataUseCase = loadFinancialDataUseCase,
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
      final data = await _loadFinancialDataUseCase(
        customerId: state.customerId,
        forceRefresh: forceRefresh,
      );

      emit(
        state.copyWith(
          financialData: data,
          busy: false,
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
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
