import 'package:collection/collection.dart';

import '../../dtos.dart';
import '../../helpers.dart';

/// Data transfer object representing a transaction qualifying for the offer.
class OfferTransactionDTO {
  /// The transaction id.
  int? id;

  /// The related offer id.
  int? offerId;

  /// The type of the reward.
  RewardTypeDTO? rewardType;

  /// The transaction name.
  String? description;

  /// The transaction amount.
  double? transactionAmount;

  /// The amount rewarded as a part of this transaction.
  double? rewardAmount;

  /// The [rewardAmount] currency.
  String? currency;

  /// The date when this transaction was created;
  DateTime? created;

  /// The date when this transaction was last updated.
  DateTime? updated;

  /// The transaction error.
  String? error;

  /// Creates [OfferTransactionDTO].
  OfferTransactionDTO({
    this.id,
    required this.offerId,
    this.rewardType,
    this.description,
    this.transactionAmount,
    this.rewardAmount,
    this.currency,
    this.created,
    this.updated,
    this.error,
  });

  /// Creates [OfferTransactionDTO] from a json map.
  factory OfferTransactionDTO.fromJson(Map<String, dynamic> json) {
    return OfferTransactionDTO(
      id: JsonParser.parseInt(json['offer_transaction_id']),
      offerId: JsonParser.parseInt(json['offer_id']),
      rewardType: RewardTypeDTO.fromRaw(json['type']),
      description: json['description'],
      transactionAmount: JsonParser.parseDouble(json['transaction_amount']),
      rewardAmount: JsonParser.parseDouble(json['reward_amount']),
      currency: json['currency'],
      created: JsonParser.parseDate(json['ts_created']),
      updated: JsonParser.parseDate(json['ts_updated']),
      error: json['error'],
    );
  }

  /// Creates [OfferTransactionDTO]s from a list of json maps.
  static List<OfferTransactionDTO> fromJsonList(List json) => json
      .map((transactionJson) => OfferTransactionDTO.fromJson(transactionJson))
      .toList();
}

/// The status of an offer transaction
// TODO: flesh this out. See all use cases.
class OfferTransactionStatusDTO extends EnumDTO {
  /// The offer is complete
  static const complete = OfferTransactionStatusDTO._internal('C');

  /// All the possible statuses for the offer transaction
  static const List<OfferTransactionStatusDTO> values = [
    complete,
  ];

  const OfferTransactionStatusDTO._internal(String value)
      : super.internal(value);

  /// Creates a [OfferTransactionStatusDTO] from a `String`.
  static OfferTransactionStatusDTO? fromRaw(String? raw) =>
      values.firstWhereOrNull(
        (val) => val.value == raw,
      );
}
