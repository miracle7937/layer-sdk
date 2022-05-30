import '../helpers.dart';

/// Represents a customer's card transaction
/// as provided by the infobanking service
class CardTransactionDTO {
  /// Unique transaction identifier
  int? transactionId;

  /// Transaction description
  String? description;

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

  /// Card balance after the transaction
  double? balance;

  /// Whether the `amount` and `balance` should be shown
  bool balanceVisible;

  /// This is a placeholder until the BE returns us
  /// with the location of the transaction
  /// TODO(VF): Correct this once we have the data
  String? location;

  /// Creates a new [CardTransactionDTO]
  CardTransactionDTO({
    this.transactionId,
    this.description,
    this.currency,
    this.reference,
    this.valueDate,
    this.postingDate,
    this.amount,
    this.location,
    this.balance,
    this.balanceVisible = true,
  });

  /// Creates a new instance of [CardTransactionDTO] from a JSON
  factory CardTransactionDTO.fromJson(Map<String, dynamic> map) {
    return CardTransactionDTO(
      transactionId: map['txn_id'],
      description: map['bank_desc'],
      currency: map['currency'],
      reference: map['reference'],
      valueDate: JsonParser.parseDate(map['value_date']),
      postingDate: JsonParser.parseDate(map['posting_date']),
      amount:
          map['amount'] is num ? JsonParser.parseDouble(map['amount']) : 0.0,
      location: map['location'],
      balance: map['balance'] is num ? map['balance'] : 0.0,
      balanceVisible: !(map['amount'] is String &&
              map['amount'].toLowerCase().contains('x')) &&
          !(map['balance'] is String &&
              map['balance'].toLowerCase().contains('x')),
    );
  }

  /// Creates a list of [CardTransactionDTO] from a JSON list
  static List<CardTransactionDTO> fromJsonList(
          List<Map<String, dynamic>> json) =>
      json.map(CardTransactionDTO.fromJson).toList(growable: false);
}
