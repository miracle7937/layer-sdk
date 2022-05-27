import 'package:collection/collection.dart';

import '../../dtos.dart';
import '../../helpers.dart';

///Data transfer object representing an offer's merchant
class MerchantDTO {
  ///The id of the merchant
  String? id;

  ///The redemption type of the merchant
  RedemptionTypeDTO? redemptionType;

  ///The list of [CategoryDTO] of the merchant
  List<CategoryDTO>? categories;

  ///The merchant's description
  String? description;

  ///The merchant's image URL
  String? imageURL;

  ///The list of [MerchantLocationDTO] of the merchant
  List<MerchantLocationDTO>? locations;

  ///The name of the merchant
  String? name;

  ///When the merchant was created
  DateTime? created;

  ///Last time the merchant was updated
  DateTime? updated;

  ///Creates a new [MerchantDTO]
  MerchantDTO({
    this.id,
    this.redemptionType,
    this.categories,
    this.description,
    this.imageURL,
    this.locations,
    this.name,
    this.created,
    this.updated,
  });

  ///Creates a [MerchantDTO] form a JSON object
  factory MerchantDTO.fromJson(Map<String, dynamic> json) => MerchantDTO(
        id: json['merchant_id'],
        redemptionType: RedemptionTypeDTO.fromRaw(json['redemption_type']),
        categories: json['merchant']['categories'] == null
            ? []
            : CategoryDTO.fromJsonList(json['merchant']['categories']),
        description: json['merchant']['description'],
        imageURL: json['merchant']['image_url'],
        locations: json['merchant']['locations'] == null
            ? []
            : MerchantLocationDTO.fromJsonList(json['merchant']['locations']),
        name: json['merchant']['merchant_name'],
        created: JsonParser.parseDate(json['merchant']['ts_created']),
        updated: JsonParser.parseDate(json['merchant']['ts_updated']),
      );

  /// Creates a list of [MerchantDTO]s from the given JSON list.
  static List<MerchantDTO> fromJsonList(List json) =>
      json.map((merchant) => MerchantDTO.fromJson(merchant)).toList();
}

///Data transfer object representing the possible redemption types for
///a merchant
class RedemptionTypeDTO extends EnumDTO {
  ///Card transaction data - activation
  static const cardActivation = RedemptionTypeDTO._internal('A');

  ///Card transaction data - no activation
  static const cardNoActivation = RedemptionTypeDTO._internal('B');

  ///Coupon with QR code
  static const couponQR = RedemptionTypeDTO._internal('C');

  ///Voucher - no activation
  static const voucherNoActivation = RedemptionTypeDTO._internal('D');

  ///Voucher - activation
  static const voucherActivation = RedemptionTypeDTO._internal('E');

  const RedemptionTypeDTO._internal(String value) : super.internal(value);

  /// All the possible redemption types for the merchant
  static const List<RedemptionTypeDTO> values = [
    cardActivation,
    cardNoActivation,
    couponQR,
    voucherNoActivation,
    voucherActivation,
  ];

  /// Creates a [RedemptionTypeDTO] from a `String`.
  static RedemptionTypeDTO? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw,
      );
}
