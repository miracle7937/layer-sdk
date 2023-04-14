import 'package:bloc/bloc.dart';

import '../../../data_layer/dtos/financial/income_expense_dto.dart';
import '../../../domain_layer/use_cases/financial/get_incomes_expenses_use_case.dart';
import '../../extensions.dart';
import 'income_expense_states.dart';

/// Cubit responsible for retrieving the incomes and expenses
class IncomeExpenseCubit extends Cubit<IncomeExpenseState> {
  final IncomeExpenseUseCase _getCustomerIncomeExpenseUseCase;

  /// Creates a new instance of [IncomeExpenseCubit]
  IncomeExpenseCubit({
    required IncomeExpenseUseCase getCustomerIncomeExpenseUseCase,
    String? accountId,
    required DateTime startDate,
    required DateTime endDate,
  })  : _getCustomerIncomeExpenseUseCase = getCustomerIncomeExpenseUseCase,
        super(
          IncomeExpenseState(
            accountId: accountId ?? '',
            startDate: startDate,
            endDate: endDate,
          ),
        );

  /// Loads incomes and expenses of account
  Future<void> load(
      {required String accountId,
      DateTime? startDate,
      DateTime? endDate,
      IncomeExpenseInterval interval = IncomeExpenseInterval.month}) async {
    try {
      emit(
        state.copyWith(
          accountId: accountId,
          startDate: startDate,
          endDate: endDate,
          actions: state.addAction(IncomeExpenseAction.load),
          errors: state.removeErrorForAction(
            IncomeExpenseAction.load,
          ),
        ),
      );
      final incomeExpense = await _getCustomerIncomeExpenseUseCase(
        toDate: state.endDate,
        fromDate: state.startDate,
        interval: interval,
        accountId: accountId,
      );

      emit(
        state.copyWith(
          incomeExpense: incomeExpense,
          actions: state.removeAction(
            IncomeExpenseAction.load,
          ),
          errors: state.removeErrorForAction(
            IncomeExpenseAction.load,
          ),
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          actions: state.removeAction(
            IncomeExpenseAction.load,
          ),
          errors: state.addErrorFromException(
            action: IncomeExpenseAction.load,
            exception: e,
          ),
        ),
      );
    }
  }
}
