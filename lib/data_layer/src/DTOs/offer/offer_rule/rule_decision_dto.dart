import 'package:collection/collection.dart';

import '../../../helpers.dart';

///Data transfer object representing a decision for an offer rule
class RuleDecisionDTO {
  ///Dynamic decision fields:
  DecisionElementDTO? element;

  ///The operation for this decision
  DecisionOperationDTO? operation;

  ///Values to compare element with
  List<dynamic>? values;

  ///Creates a new [RuleDecisionDTO]
  RuleDecisionDTO({
    this.element,
    this.operation,
    this.values,
  });

  ///Creates a [RuleDecisionDTO] form a JSON object
  factory RuleDecisionDTO.fromJson(Map<String, dynamic> json) =>
      RuleDecisionDTO(
        element: DecisionElementDTO.fromRaw(json['element']),
        operation: DecisionOperationDTO.fromRaw(json['operation']),
        values:
            json['value'] == null ? [] : json['value'].toString().split(','),
      );

  /// Creates a list of [RuleDecisionDTO]s from the given JSON list.
  static List<RuleDecisionDTO> fromJsonList(List json) =>
      json.map((decision) => RuleDecisionDTO.fromJson(decision)).toList();
}

///Data transfer object repersenting the operation for a decision
class DecisionOperationDTO extends EnumDTO {
  /// = (default)
  static const equal = DecisionOperationDTO._internal('=');

  /// <=
  static const lessOrEqual = DecisionOperationDTO._internal('<=');

  /// >=
  static const greaterOrEqual = DecisionOperationDTO._internal('>=');

  /// <
  static const less = DecisionOperationDTO._internal('<');

  /// >
  static const greater = DecisionOperationDTO._internal('>');

  /// All the possible operations for a decision
  static const List<DecisionOperationDTO> values = [
    equal,
    lessOrEqual,
    greaterOrEqual,
    less,
    greater,
  ];

  const DecisionOperationDTO._internal(String value) : super.internal(value);

  /// Creates a [DecisionOperationDTO] from a `String`.
  static DecisionOperationDTO? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw,
      );
}

/// The type of the rule decision.
// TODO: improve the documentation of the fields, it's just copied from swagger.
class DecisionElementDTO extends EnumDTO {
  /// value can be any terminal id or list of them.
  static const posId = DecisionElementDTO._internal('pos_id');

  /// value can be any currency code or list of them;
  static const transactionCurrency =
      DecisionElementDTO._internal('transaction_currency');

  /// value is an amount;
  static const cardSpend = DecisionElementDTO._internal('card_spend');

  /// value is a number;
  static const numberOfTransactions =
      DecisionElementDTO._internal('number_of_transactions');

  /// value can be A: all campaign (default), W: week, M: month, Q: quarter,
  /// Y: year;
  static const cardSpendPeriod =
      DecisionElementDTO._internal('card_spend_period');

  /// value can be A: all campaign (default), W: week, M: month, Q: quarter,
  /// Y: year;
  static const numberOfTransactionsPeriod =
      DecisionElementDTO._internal('number_of_transactions_period');

  /// value can be A: All Transactions (default), P: Physical POS transaction,
  /// V: Online - virtual POS transactions, T: All tokenised transactions,
  /// E: ApplePay, G: GooglePay;
  static const transactionType =
      DecisionElementDTO._internal('transaction_type');

  /// value can be any country_code retrieved from GET /infobanking/v1/country
  static const nationalities = DecisionElementDTO._internal('nationalities');

  /// value can be en, fr, ar, etc., just like the language in the user_pref
  static const language = DecisionElementDTO._internal('language');

  /// value can be M or F
  static const gender = DecisionElementDTO._internal('gender');

  /// value can be any number
  static const age = DecisionElementDTO._internal('age');

  /// value can be M or S
  static const maritalStatus = DecisionElementDTO._internal('marital_status');

  /// value can be any string
  static const profession = DecisionElementDTO._internal('profession');

  /// value can be any amount
  static const income = DecisionElementDTO._internal('income');

  /// value can be any card_type_id retrieved from GET /infobanking/v1/card_type
  static const cardTypeId = DecisionElementDTO._internal('card_type_id');

  /// value can be any amount
  static const averageCardSpend =
      DecisionElementDTO._internal('average_card_spend');

  /// value can be T: 3 months, S: 6 months, Y: 12 months
  static const averageCardSpendPeriod =
      DecisionElementDTO._internal('average_card_spend_period');

  const DecisionElementDTO._internal(String value) : super.internal(value);

  /// Creates [DecisionElementDTO] from a raw value.
  static DecisionElementDTO? fromRaw(String? raw) => values.firstWhereOrNull(
        (element) => element.value == raw,
      );

  /// All possible values.
  static const List<DecisionElementDTO> values = [
    posId,
    transactionCurrency,
    cardSpend,
    numberOfTransactions,
    cardSpendPeriod,
    numberOfTransactionsPeriod,
    transactionType,
    nationalities,
    language,
    gender,
    age,
    maritalStatus,
    profession,
    income,
    cardTypeId,
    averageCardSpend,
    averageCardSpendPeriod,
  ];
}
