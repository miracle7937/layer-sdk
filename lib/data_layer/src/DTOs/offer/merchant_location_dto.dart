import 'package:collection/collection.dart';

import '../../helpers.dart';

///Data transfer object representing the merchant location
class MerchantLocationDTO {
  ///The merchant's location id
  int? id;

  ///The address of this merchant's location
  String? address;

  ///The email address of this merchant's location
  String? email;

  ///The latitude of the location
  double? latitude;

  ///The longitude of the location
  double? longitude;

  ///The location type
  MerchantLocationTypeDTO? type;

  ///The name of the merchant's location
  String? name;

  ///The phone of this merchant's location
  String? phone;

  ///The web URL of this location
  String? website;

  ///When this merchant's location was created
  DateTime? created;

  ///Last time this merchant's location was updated
  DateTime? updated;

  ///The distance in meters
  double? distance;

  ///Creates a new [MerchantLocationDTO]
  MerchantLocationDTO({
    this.id,
    this.address,
    this.email,
    this.latitude,
    this.longitude,
    this.type,
    this.name,
    this.phone,
    this.website,
    this.created,
    this.updated,
    this.distance,
  });

  ///Creates a [MerchantLocationDTO] form a JSON object
  factory MerchantLocationDTO.fromJson(Map<String, dynamic> json) =>
      MerchantLocationDTO(
        id: JsonParser.parseInt(json['location_id']),
        address: json['address'],
        email: json['email'],
        latitude: JsonParser.parseDouble(json['latitude']),
        longitude: JsonParser.parseDouble(json['longitude']),
        type: MerchantLocationTypeDTO.fromRaw(json['location_type']),
        name: json['name'],
        phone: json['phone'],
        website: json['website'],
        created: JsonParser.parseDate(json['ts_created']),
        updated: JsonParser.parseDate(json['ts_updated']),
        distance: JsonParser.parseDouble(json['distance']),
      );

  /// Creates a list of [MerchantLocationDTO]s from the given JSON list.
  static List<MerchantLocationDTO> fromJsonList(List json) =>
      json.map((location) => MerchantLocationDTO.fromJson(location)).toList();
}

///Data transfer object representing the type for a merchant location
class MerchantLocationTypeDTO extends EnumDTO {
  /// Merchant
  static const merchant = MerchantLocationTypeDTO._internal('M');

  /// All the possible types for a location
  static const List<MerchantLocationTypeDTO> values = [
    merchant,
  ];

  const MerchantLocationTypeDTO._internal(String value) : super.internal(value);

  /// Creates a [LocationTypeDTO] from a `String`.
  static MerchantLocationTypeDTO? fromRaw(String? raw) =>
      values.firstWhereOrNull(
        (val) => val.value == raw,
      );
}
