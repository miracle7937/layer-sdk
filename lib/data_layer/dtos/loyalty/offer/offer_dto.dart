import 'package:collection/collection.dart';

import '../../../dtos.dart';
import '../../../helpers.dart';

///Data transfer object representing an offer
class OfferDTO {
  ///The id of the offer
  int? id;

  ///The name as seen by console users
  String? consoleName;

  ///The name as seen by customer users
  String? customerName;

  ///When the offer starts
  DateTime? starts;

  ///When the offer ends
  DateTime? ends;

  ///The imageURL of the offer
  String? imageURL;

  ///The description of the offer
  String? description;

  ///The short description of the offer
  String? shortDescription;

  ///The terms and conditions URL of the offer
  String? tncURL;

  ///The terms and conditions text
  String? tncText;

  ///The offer status
  OfferStatusDTO? status;

  ///The [MerchantDTO] of the offer
  MerchantDTO? merchant;

  ///The list of [OfferRuleDTO] of the offer
  List<OfferRuleDTO>? rules;

  ///The offer type
  OfferTypeDTO? type;

  ///The currency of the offer
  String? currency;

  ///Creates a new [OfferDTO] object
  OfferDTO({
    this.id,
    this.consoleName,
    this.customerName,
    this.starts,
    this.ends,
    this.imageURL,
    this.description,
    this.shortDescription,
    this.tncURL,
    this.tncText,
    this.status,
    this.merchant,
    this.rules,
    this.type,
    this.currency,
  });

  ///Creates a [OfferDTO] form a JSON object
  factory OfferDTO.fromJson(Map<String, dynamic> json) => OfferDTO(
        id: JsonParser.parseInt(json['offer_id']),
        consoleName: json['console_name'],
        customerName: json['customer_name'],
        starts: JsonParser.parseDate(json['ts_start']),
        ends: JsonParser.parseDate(json['ts_end']),
        imageURL: json['image_url'],
        description: json['description'],
        shortDescription: json['short_description'],
        tncURL: json['tnc_url'],
        tncText: json['tnc_text'],
        status: OfferStatusDTO.fromRaw(json['status']),
        merchant:
            json['merchant_offer'] == null || json['merchant_offer'].isEmpty
                ? null
                : MerchantDTO.fromJson(json['merchant_offer'].first),
        rules: json['rule_offer'] == null
            ? null
            : OfferRuleDTO.fromJsonList(List<Map<String, dynamic>>.from(
                json['rule_offer'].where((rule) => rule['reward'] != null),
              )),
        type: OfferTypeDTO.fromRaw(json['type']),
        currency: json['currency'],
      );

  /// Creates a list of [OfferDTO]s from the given JSON list.
  static List<OfferDTO> fromJsonList(List<Map<String, dynamic>> json) =>
      json.map(OfferDTO.fromJson).toList();
}

///Data transfer object representing the status of an offer
class OfferStatusDTO extends EnumDTO {
  /// The offer is active
  static const active = OfferStatusDTO._internal('A');

  /// The offer is pending of approval.
  static const pending = OfferStatusDTO._internal('P');

  /// The offer is deleted
  static const deleted = OfferStatusDTO._internal('D');

  /// The offer is stopped
  static const stopped = OfferStatusDTO._internal('S');

  /// All the possible statuses for the offer
  static const List<OfferStatusDTO> values = [
    active,
    pending,
    deleted,
    stopped,
  ];

  const OfferStatusDTO._internal(String value) : super.internal(value);

  /// Creates a [OfferStatusDTO] from a `String`.
  static OfferStatusDTO? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw,
      );
}

///Data transfer object repersenting the offer type
class OfferTypeDTO extends EnumDTO {
  ///Bank campaign
  static const bankCampaign = OfferTypeDTO._internal('B');

  ///Card scheme
  static const cardScheme = OfferTypeDTO._internal('C');

  ///Merchant
  static const merchant = OfferTypeDTO._internal('M');

  ///Card scheme Merchant
  static const cardSchemeMerchant = OfferTypeDTO._internal('CM');

  /// All the possible types for the reward
  static const List<OfferTypeDTO> values = [
    bankCampaign,
    cardScheme,
    merchant,
    cardSchemeMerchant,
  ];

  const OfferTypeDTO._internal(String value) : super.internal(value);

  /// Creates a [OfferTypeDTO] from a `String`.
  static OfferTypeDTO? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw,
      );
}
