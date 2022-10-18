/// Represents a customer's account incomes and expenses
class IncomeExpenseDTO {
  /// The expense
  final num? expense;

  /// The account income
  final num? income;

  /// The period start date
  final String? periodStartDate;

  /// This period end date
  final String? periodEndDate;

  /// The currency
  final String? prefCurrency;

  /// Creates a new [IncomeExpenseDTO]
  IncomeExpenseDTO({
    this.periodEndDate,
    this.periodStartDate,
    this.prefCurrency,
    this.income,
    this.expense,
  });

  /// Creates a new instance of [IncomeExpenseDTO] from a JSON
  factory IncomeExpenseDTO.fromJson(Map<String, dynamic> json) {
    return IncomeExpenseDTO(
      periodEndDate: json['period_end_date'],
      periodStartDate: json['period_start_date'],
      prefCurrency: json['pref_currency'],
      income: json['income'],
      expense: json['expense'],
    );
  }

  /// Creates a list of [IncomeExpenseDTO] from a JSON list
  static List<IncomeExpenseDTO> fromJsonList(List<Map<String, dynamic>> json) {
    return json.map(IncomeExpenseDTO.fromJson).toList(growable: false);
  }
}
