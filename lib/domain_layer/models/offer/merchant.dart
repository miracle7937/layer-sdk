import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../models.dart';

///The redemption type of the merchant
enum RedemptionType {
  ///Card transaction data - activation
  cardActivation,

  ///Card transaction data - no activation
  cardNoActivation,

  ///Coupon with QR code
  couponQR,

  ///Voucher - no activation
  voucherNoActivation,

  ///Voucher - activation
  voucherActivation,
}

///Contains the data of a merchant
class Merchant extends Equatable {
  ///The id of the merchant
  final String? id;

  ///The redemption type of the merchant
  final RedemptionType? redemptionType;

  ///The list of [Category] of the merchant
  final UnmodifiableListView<Category>? categories;

  ///The merchant's description
  final String? description;

  ///The merchant's image URL
  final String? imageURL;

  ///The list of [MerchantLocation] of the merchant
  final UnmodifiableListView<MerchantLocation>? locations;

  ///The name of the merchant
  final String? name;

  ///When the merchant was created
  final DateTime? created;

  ///Last time the merchant was updated
  final DateTime? updated;

  ///Creates a new [Merchant]
  Merchant({
    this.id,
    this.redemptionType,
    Iterable<Category>? categories,
    this.description,
    this.imageURL,
    Iterable<MerchantLocation>? locations,
    this.name,
    this.created,
    this.updated,
  })  : categories =
            categories != null ? UnmodifiableListView(categories) : null,
        locations = locations != null ? UnmodifiableListView(locations) : null;

  ///Creates a copy of this merchant with different values
  Merchant copyWith({
    String? id,
    RedemptionType? redemptionType,
    Iterable<Category>? categories,
    String? description,
    String? imageURL,
    Iterable<MerchantLocation>? locations,
    String? name,
    DateTime? created,
    DateTime? updated,
  }) =>
      Merchant(
        id: id ?? this.id,
        redemptionType: redemptionType ?? this.redemptionType,
        categories: categories ?? this.categories,
        description: description ?? this.description,
        imageURL: imageURL ?? this.imageURL,
        locations: locations ?? this.locations,
        name: name ?? this.name,
        created: created ?? this.created,
        updated: updated ?? this.updated,
      );

  @override
  List<Object?> get props => [
        id,
        redemptionType,
        categories,
        description,
        imageURL,
        locations,
        name,
        created,
        updated,
      ];
}
