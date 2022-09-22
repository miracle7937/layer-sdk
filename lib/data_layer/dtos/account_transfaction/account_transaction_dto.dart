import '../../helpers.dart';

/// Represents a customer's account transaction
/// as provided by the infobanking service
class AccountTransactionDTO {
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

  /// Account balance after the transaction
  double? balance;

  /// Whether the `amount` and `balance` should be shown
  bool balanceVisible;

  /// This is a placeholder until the BE returns us
  /// with the location of the transaction
  /// TODO(VF): Correct this once we have the data
  String? location;

  /// Creates a new [AccountTransactionDTO]
  AccountTransactionDTO({
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

  /// Creates a new instance of [AccountTransactionDTO] from a JSON
  factory AccountTransactionDTO.fromJson(Map<String, dynamic> map) =>
      AccountTransactionDTO(
        transactionId: map['txn_id'],
        description: map['bank_desc'],
        currency: map['currency'],
        reference: map['reference'],
        valueDate: JsonParser.parseDate(map['value_date']),
        postingDate: JsonParser.parseDate(map['posting_date']),
        amount: map['amount'] is num
            ? JsonParser.parseDouble(
                map['amount'],
              )
            : 0.0,
        location: map['location'],
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

  /// Creates a list of [AccountTransactionDTO] from a JSON list
  static List<AccountTransactionDTO> fromJsonList(
      List<Map<String, dynamic>> json) {
    return json.map(AccountTransactionDTO.fromJson).toList();
  }
}
