import 'package:equatable/equatable.dart';

///The location type
enum MerchantLocationType {
  /// Merchant
  merchant,
}

///Contains the data for a Merchant's location
class MerchantLocation extends Equatable {
  ///The merchant's location id
  final int? id;

  ///The address of this merchant's location
  final String? address;

  ///The email address of this merchant's location
  final String? email;

  ///The latitude of the location
  final double? latitude;

  ///The longitude of the location
  final double? longitude;

  ///The location type
  final MerchantLocationType type;

  ///The name of the merchant's location
  final String? name;

  ///The phone of this merchant's location
  final String? phone;

  ///The web URL of this location
  final String? website;

  ///When this merchant's location was created
  final DateTime? created;

  ///Last time this merchant's location was updated
  final DateTime? updated;

  ///The distance in meters
  final double? distance;

  ///Creates a new [MerchantLocation]
  MerchantLocation({
    this.id,
    this.address,
    this.email,
    this.latitude,
    this.longitude,
    required this.type,
    this.name,
    this.phone,
    this.website,
    this.created,
    this.updated,
    this.distance,
  });

  ///Creates a copy of this merchant's location with different values
  MerchantLocation copyWith({
    int? id,
    String? address,
    String? email,
    double? latitude,
    double? longitude,
    MerchantLocationType? type,
    String? name,
    String? phone,
    String? website,
    DateTime? created,
    DateTime? updated,
    double? distance,
  }) =>
      MerchantLocation(
        id: id ?? this.id,
        address: address ?? this.address,
        email: email ?? this.email,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        type: type ?? this.type,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        website: website ?? this.website,
        created: created ?? this.created,
        updated: updated ?? this.updated,
        distance: distance ?? this.distance,
      );

  @override
  List<Object?> get props => [
        id,
        address,
        email,
        latitude,
        longitude,
        type,
        name,
        phone,
        website,
        created,
        updated,
        distance,
      ];
}
