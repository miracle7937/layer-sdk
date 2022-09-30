/// Represents a customer's BankingProduct transaction
/// as provided by the infobanking service
class MinMaxTransactionAmountDTO {
  ///
  List<String>? currencies;

  ///
  double? minAmount;

  ///
  double? maxAmount;

  /// Creates a new [MinMaxTransactionAmountDTO]
  MinMaxTransactionAmountDTO({
    this.currencies,
    this.maxAmount,
    this.minAmount,
  });

  /// Creates a new instance of [MinMaxTransactionAmountDTO] from a JSON
  factory MinMaxTransactionAmountDTO.fromJson(Map<String, dynamic> map) =>
      MinMaxTransactionAmountDTO(
        currencies: map['currencies']?.cast<String>(),
        minAmount: (map["min_amount"] ?? 0).toDouble(),
        maxAmount: (map["max_amount"] ?? 0).toDouble(),
      );

  /// Creates a list of [MinMaxTransactionAmountDTO] from a JSON list
  static List<MinMaxTransactionAmountDTO> fromJsonList(
          List<Map<String, dynamic>> json) =>
      json.map(MinMaxTransactionAmountDTO.fromJson).toList(growable: false);
}
