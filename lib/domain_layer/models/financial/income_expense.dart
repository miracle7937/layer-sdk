import 'package:equatable/equatable.dart';

/// Account incomes and expenses
class IncomeExpense extends Equatable {
  /// The account income
  final double? income;

  /// The account expense
  final double? expense;

  /// The period start date
  final DateTime? periodStartDate;

  /// This period end date
  final DateTime? periodEndDate;

  /// The preferred currency
  final String? prefCurrency;

  /// Creates a new immutable instance of [IncomeExpense]
  const IncomeExpense({
    this.periodEndDate,
    this.periodStartDate,
    this.prefCurrency,
    this.income,
    this.expense,
  });

  @override
  List<Object?> get props => [
        periodEndDate,
        periodStartDate,
        prefCurrency,
        income,
        expense,
      ];
}
