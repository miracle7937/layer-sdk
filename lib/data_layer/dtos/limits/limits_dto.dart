import '../../../_migration/data_layer/src/helpers/json_parser.dart';

/// Holds the data of the limits information.
class LimitsDTO {
  ///
  Map<String, dynamic> json;

  /// Minimum Transfer Amount
  int? min;

  /// Minimum Bill Payment Amount per transaction
  int? minBill;

  /// Minimum Topup Amount per transaction
  int? minTopup;

  /// Customer cumulative limit
  int? limCumulativeDaily;

  /// None CASA Wallet Balance Limit
  int? limWalletBalance;

  /// CASA Wallet Balance Limit
  int? limLinkedWalletBalance;

  /// Minimum Remittance Transfer Amount
  int? minMcsxb;

  /// Creates a new [LimitsDTO]
  LimitsDTO({
    required this.json,
    this.min,
    this.minBill,
    this.minTopup,
    this.limCumulativeDaily,
    this.limWalletBalance,
    this.limLinkedWalletBalance,
    this.minMcsxb,
  });

  /// Creates [LimitsDTO] from JSON
  factory LimitsDTO.fromJson(Map<String, dynamic> json) => LimitsDTO(
        json: json,
        min: JsonParser.parseInt(json["min"]),
        minBill: JsonParser.parseInt(json["min_bill"]),
        minTopup: JsonParser.parseInt(json["min_topup"]),
        limCumulativeDaily: JsonParser.parseInt(json["lim_cumulative_daily"]),
        limWalletBalance: JsonParser.parseInt(json["lim_wallet_balance"]),
        limLinkedWalletBalance:
            JsonParser.parseInt(json["lim_linked_wallet_balance"]),
        minMcsxb: JsonParser.parseInt(json["min_mcsxb"]),
      );

  /// Converts a [LimitsDTO] to JSON excluding `lim_cumulative_daily`
  Map<String, dynamic> toCustomerJson() => json
    ..remove('lim_cumulative_daily')
    ..addAll({
      "min": min,
      "min_bill": minBill,
      "min_topup": minTopup,
      "lim_cumulative_daily": limCumulativeDaily,
      "lim_wallet_balance": limWalletBalance,
      "lim_linked_wallet_balance": limLinkedWalletBalance,
      "min_mcsxb": minMcsxb,
    });

  /// Converts a [LimitsDTO] to JSON including only `lim_cumulative_daily`
  Map<String, dynamic> toCustomerDefinedJson() =>
      {'lim_cumulative_daily': json['lim_cumulative_daily']};
}
