import '../../_migration/data_layer/src/helpers/json_parser.dart';

/// Represents a customer's BankingProduct transaction
/// as provided by the infobanking service
class BankingProductTransactionDTO {
  /// Unique transaction identifier
  int? transactionId;

  /// Transaction description
  String? description;

  /// Card id
  String? cardId;

  /// Account id
  String? accountId;

  /// Currency used in the transaction
  String? currency;

  /// Transaction reference
  String? reference;

  /// Date that the transaction was made
  DateTime? valueDate;

  /// Date that the transaction payment was made
  DateTime? postingDate;

  /// Amount used in this transaction
  /// Can be negative or positive
  double? amount;

  /// BankingProduct balance after the transaction
  double? balance;

  /// Whether the `amount` and `balance` should be shown
  bool balanceVisible;

  /// Creates a new [BankingProductTransactionDTO]
  BankingProductTransactionDTO({
    this.transactionId,
    this.cardId,
    this.accountId,
    this.description,
    this.currency,
    this.reference,
    this.valueDate,
    this.postingDate,
    this.amount,
    this.balance,
    this.balanceVisible = true,
  });

  /// Creates a new instance of [BankingProductTransactionDTO] from a JSON
  factory BankingProductTransactionDTO.fromJson(Map<String, dynamic> map) =>
      BankingProductTransactionDTO(
        transactionId: map['txn_id'],
        description: map['bank_desc'],
        cardId: map['card_id'],
        accountId: map['account_id'],
        currency: map['currency'],
        reference: map['reference'],
        valueDate: JsonParser.parseDate(map['value_date']),
        postingDate: JsonParser.parseDate(map['posting_date']),
        amount: map['amount'] is num
            ? JsonParser.parseDouble(
                map['amount'],
              )
            : 0.0,
        balance: map['balance'] is num
            ? JsonParser.parseDouble(
                map['balance'],
              )
            : 0.0,
        balanceVisible: !(map['amount'] is String &&
                map['amount'].toLowerCase().contains('x')) &&
            !(map['balance'] is String &&
                map['balance'].toLowerCase().contains('x')),
      );

  /// Creates a list of [BankingProductTransactionDTO] from a JSON list
  static List<BankingProductTransactionDTO> fromJsonList(
          List<Map<String, dynamic>> json) =>
      json.map(BankingProductTransactionDTO.fromJson).toList(growable: false);
}
