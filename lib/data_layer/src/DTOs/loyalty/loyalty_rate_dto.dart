import '../../helpers.dart';

/// Model responsible for holding Loyalty Rates data
class LoyaltyRateDTO {
  /// Rate ID
  final String? id;

  /// Date of creation
  final DateTime? createdAt;

  /// Date when the record was updated
  final DateTime? updatedAt;

  /// When the rate start
  final DateTime? startDate;

  /// Rate amount
  final num? rate;

  /// [LoyaltyRateDTO] constructor
  LoyaltyRateDTO({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.startDate,
    this.rate,
  });

  /// Returns a [LoyaltyRateDTO] from json map
  factory LoyaltyRateDTO.fromJson(Map<String, dynamic> json) {
    return LoyaltyRateDTO(
      id: (json['rate_id']),
      createdAt: JsonParser.parseDate(json['ts_created']),
      updatedAt: JsonParser.parseDate(json['ts_updated']),
      startDate: JsonParser.parseDate(json['ts_start']),
      rate: JsonParser.parseDouble(json['rate']),
    );
  }

  /// Return a list of [LoyaltyRateDTO] from a json list
  static List<LoyaltyRateDTO> fromJsonList(List json) {
    return json.map((l) => LoyaltyRateDTO.fromJson(l)).toList();
  }
}
