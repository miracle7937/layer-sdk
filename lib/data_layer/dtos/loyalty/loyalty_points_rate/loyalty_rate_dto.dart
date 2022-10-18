import '../../../helpers.dart';

/// Model responsible for holding Loyalty points rates data
class LoyaltyPointsRateDTO {
  /// Rate ID
  final String? id;

  /// Date of creation
  final DateTime? createdAt;

  /// Date when the record was updated
  final DateTime? updatedAt;

  /// When the rate start
  final DateTime? startDate;

  /// Rate amount
  final double? rate;

  /// [LoyaltyPointsRateDTO] constructor
  LoyaltyPointsRateDTO({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.startDate,
    this.rate,
  });

  /// Returns a [LoyaltyPointsRateDTO] from json map
  factory LoyaltyPointsRateDTO.fromJson(Map<String, dynamic> json) =>
      LoyaltyPointsRateDTO(
        id: (json['rate_id']),
        createdAt: JsonParser.parseDate(json['ts_created']),
        updatedAt: JsonParser.parseDate(json['ts_updated']),
        startDate: JsonParser.parseDate(json['ts_start']),
        rate: JsonParser.parseDouble(json['rate']),
      );

  /// Return a list of [LoyaltyPointsRateDTO] from a json list
  static List<LoyaltyPointsRateDTO> fromJsonList(
          List<Map<String, dynamic>> json) =>
      json.map(LoyaltyPointsRateDTO.fromJson).toList();
}
