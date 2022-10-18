import 'package:equatable/equatable.dart';

/// Account incomes and expenses
class IncomeExpense extends Equatable {
  /// The account income
  final num? income;

  /// The account expense
  final num? expense;

  /// The period start date
  final String? periodStartDate;

  /// This period end date
  final String? periodEndDate;

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
