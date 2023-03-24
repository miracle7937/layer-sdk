import '../../errors.dart';
import '../../helpers.dart';

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

/// The available intervals for incomes and expenses
enum IncomeExpenseIntervalDTO {
  /// month.
  month('month'),

  /// Unknown.
  unknown('unknown');

  /// The string value for the [IncomeExpenseIntervalDTO].
  final String value;

  /// Creates a new [IncomeExpenseIntervalDTO] with the passed value.
  const IncomeExpenseIntervalDTO(this.value);

  /// Creates a new [IncomeExpenseIntervalDTO] from a passed string.
  factory IncomeExpenseIntervalDTO.fromString(String status) =>
      values.singleWhere(
        (value) => value.value == status,
        orElse: () => unknown,
      );
}

/// The available intervals
enum IncomeExpenseInterval {
  /// Month.
  month,
}

/// Extension on [IncomeExpenseIntervalDTO].
extension IncomeExpenseIntervalDTOExtension on IncomeExpenseIntervalDTO {
  /// Maps [IncomeExpenseIntervalDTO] into [IncomeExpenseInterval].
  IncomeExpenseInterval? toStatus() {
    switch (this) {
      case IncomeExpenseIntervalDTO.month:
        return IncomeExpenseInterval.month;

      case IncomeExpenseIntervalDTO.unknown:
        throw MappingException(
          from: IncomeExpenseIntervalDTO,
          to: IncomeExpenseInterval,
        );
    }
  }
}

/// Extension on [IncomeExpenseInterval].
extension IncomeExpenseIntervalExtension on IncomeExpenseInterval {
  /// Maps [IncomeExpenseInterval] into [IncomeExpenseIntervalDTO].
  IncomeExpenseIntervalDTO? toStatusDTO() {
    switch (this) {
      case IncomeExpenseInterval.month:
        return IncomeExpenseIntervalDTO.month;

      default:
        throw MappingException(
          from: IncomeExpenseInterval,
          to: IncomeExpenseIntervalDTO,
        );
    }
  }
}
