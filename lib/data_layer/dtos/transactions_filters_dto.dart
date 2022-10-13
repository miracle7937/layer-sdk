/// Represents a transaction filters object
class TransactionFiltersDTO {
  /// the list of currencies
  List<String>? currencies;

  /// the min amount for the  slider
  double? minAmount;

  /// the max amount for the slider
  double? maxAmount;

  /// Creates a new [TransactionFiltersDTO]
  TransactionFiltersDTO({
    this.currencies,
    this.maxAmount,
    this.minAmount,
  });

  /// Creates a new instance of [TransactionFiltersDTO] from a JSON
  factory TransactionFiltersDTO.fromJson(Map<String, dynamic> map) =>
      TransactionFiltersDTO(
        currencies: map['currencies']?.cast<String>(),
        minAmount: (map["min_amount"] ?? 0).toDouble(),
        maxAmount: (map["max_amount"] ?? 0).toDouble(),
      );

  /// Creates a list of [TransactionFiltersDTO] from a JSON list
  static List<TransactionFiltersDTO> fromJsonList(
          List<Map<String, dynamic>> json) =>
      json.map(TransactionFiltersDTO.fromJson).toList(growable: false);
}
