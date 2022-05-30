import '../../helpers.dart';

/// Data transfer object representing group data
/// of transactions qualifying for an offer.
class OfferTransactionGroupDTO {
  /// The count of the transactions for this offer.
  int? count;

  /// The sum of qualifying transactions amounts.
  double? totalTransactionAmount;

  /// The sum of qualifying transactions rewards.
  double? totalRewardAmount;

  /// The id of the related offer.
  int? offerId;

  /// Creates [OfferTransactionGroupDTO].
  OfferTransactionGroupDTO({
    this.count,
    this.totalTransactionAmount,
    this.totalRewardAmount,
    this.offerId,
  });

  /// Creates [OfferTransactionGroupDTO] from a json map.
  factory OfferTransactionGroupDTO.fromJson(Map<String, dynamic> json) {
    return OfferTransactionGroupDTO(
      count: JsonParser.parseInt(json['count']),
      totalTransactionAmount:
          JsonParser.parseDouble(json['total_transaction_amount']),
      totalRewardAmount: JsonParser.parseDouble(json['total_reward_amount']),
      offerId: JsonParser.parseInt(json['offer_id']),
    );
  }

  /// Creates [OfferTransactionGroupDTO]s from a list of json maps.
  static List<OfferTransactionGroupDTO> fromJsonList(
          List<Map<String, dynamic>> json) =>
      json.map(OfferTransactionGroupDTO.fromJson).toList();
}
