import '../../dtos.dart';
import '../../helpers.dart';

/// Data transfer object representing an offer transaction response.
class OfferTransactionResponseDTO {
  /// Total count of qualifying transactions.
  int? totalCount;

  /// The sum of all qualifying transactions amounts.
  double? totalTransactionAmount;

  /// The sum of all qualifying transactions rewards.
  double? totalRewardAmount;

  /// The transaction data grouped by offers.
  List<OfferTransactionGroupDTO>? offerGroups;

  /// The qualifying transactions.
  List<OfferTransactionDTO>? transactions;

  /// Creates [OfferTransactionResponseDTO].
  OfferTransactionResponseDTO({
    this.totalCount,
    this.totalTransactionAmount,
    this.totalRewardAmount,
    this.offerGroups,
    this.transactions,
  });

  /// Creates [OfferTransactionResponseDTO] from json map.
  factory OfferTransactionResponseDTO.fromJson(Map<String, dynamic> json) {
    return OfferTransactionResponseDTO(
      totalCount: JsonParser.parseInt(json['count']),
      totalTransactionAmount:
          JsonParser.parseDouble(json['total_transaction_amount']),
      totalRewardAmount: JsonParser.parseDouble(json['total_reward_amount']),
      offerGroups: OfferTransactionGroupDTO.fromJsonList(json['offer_total']),
      transactions: OfferTransactionDTO.fromJsonList(json['offer_transaction']),
    );
  }
}
