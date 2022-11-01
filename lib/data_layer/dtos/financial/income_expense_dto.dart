import 'package:collection/collection.dart';

import '../../../_migration/data_layer/src/helpers.dart';

/// Represents a customer's account incomes and expenses
class IncomeExpenseDTO {
  /// The expense
  final double? expense;

  /// The account income
  final double? income;

  /// The period start date
  final DateTime? periodStartDate;

  /// This period end date
  final DateTime? periodEndDate;

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
      periodEndDate: JsonParser.parseStringDate(json['period_end_date']),
      periodStartDate: JsonParser.parseStringDate(json['period_start_date']),
      prefCurrency: json['pref_currency'],
      income: JsonParser.parseDouble(json['income']),
      expense: JsonParser.parseDouble(json['expense']),
    );
  }

  /// Creates a list of [IncomeExpenseDTO] from a JSON list
  static List<IncomeExpenseDTO> fromJsonList(List<Map<String, dynamic>> json) {
    return json.map(IncomeExpenseDTO.fromJson).toList(growable: false);
  }
}

/// The general format of this variable.
class IncomeExpenseInterval extends EnumDTO {
  /// Image
  static const month = IncomeExpenseInterval._('month');

  /// Returns all the values available.
  static const List<IncomeExpenseInterval> values = [month];

  const IncomeExpenseInterval._(String value) : super.internal(value);

  /// Creates a new [IncomeExpenseInterval] from a raw text.
  static IncomeExpenseInterval? fromRaw(String? raw) {
    // We transform raw to lowercase as there's a bug with the textArea
    // coming from the backend in certain processes.
    final effectiveRaw = raw?.toLowerCase();

    if (effectiveRaw == null) return null;

    return values.firstWhereOrNull(
      (val) => val.value.toLowerCase() == effectiveRaw,
    );
  }

  @override
  String toString() => 'IncomeExpenseInterval{$value}';
}

/// Extension that maps [InboxReportCategoryDTO]
extension IncomeExpenseIntervalMapper on IncomeExpenseInterval {
  /// Maps a [InboxReportCategoryDTO] into a [InboxReportCategory]
  IncomeExpenseInterval toInterval() {
    switch (this) {
      case IncomeExpenseInterval.month:
        return IncomeExpenseInterval.month;
      default:
        return IncomeExpenseInterval.month;
    }
  }
}
