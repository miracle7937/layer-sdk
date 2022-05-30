import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../../models.dart';

///The status of the offer
enum OfferStatus {
  ///Active
  active,

  ///Pending approval
  pending,

  ///Deleted
  deleted,

  ///Stopped
  stopped,
}

///The offer type
enum OfferType {
  ///Bank campaign
  bankCampaign,

  ///Card scheme
  cardScheme,

  ///Merchant
  merchant,

  ///Card scheme Merchant
  cardSchemeMerchant,
}

///Contains the data of an offer
class Offer extends Equatable {
  ///The id of the offer
  final int id;

  ///The name as seen by console users
  final String? consoleName;

  ///The name as seen by customer users
  final String? customerName;

  ///When the offer starts
  final DateTime? starts;

  ///When the offer ends
  final DateTime? ends;

  ///The imageURL of the offer
  final String? imageURL;

  ///The description of the offer
  final String? description;

  ///The short description of the offer
  final String? shortDescription;

  ///The terms and conditions URL of the offer
  final String? tncURL;

  ///The terms and conditions plain text
  final String? tncText;

  ///The offer status
  final OfferStatus status;

  ///The [Merchant] of the offer
  final Merchant merchant;

  ///The list of [OfferRule] of the offer
  final UnmodifiableListView<OfferRule>? rules;

  ///The offer type
  final OfferType type;

  ///The currency of the offer
  final String? currency;

  ///Creates a new [Offer]
  Offer({
    required this.id,
    this.consoleName,
    this.customerName,
    this.starts,
    this.ends,
    this.imageURL,
    this.description,
    this.shortDescription,
    this.tncURL,
    this.tncText,
    required this.status,
    required this.merchant,
    Iterable<OfferRule>? rules,
    required this.type,
    this.currency,
  }) : rules = rules != null ? UnmodifiableListView(rules) : null;

  ///Creates a copy of this offer with different values
  Offer copyWith({
    int? id,
    String? consoleName,
    String? customerName,
    DateTime? starts,
    DateTime? ends,
    String? imageURL,
    String? description,
    String? shortDescription,
    String? tncURL,
    String? tncText,
    OfferStatus? status,
    Merchant? merchant,
    Iterable<OfferRule>? rules,
    OfferType? type,
    String? currency,
  }) =>
      Offer(
        id: id ?? this.id,
        consoleName: consoleName ?? this.consoleName,
        customerName: customerName ?? this.customerName,
        starts: starts ?? this.starts,
        ends: ends ?? this.ends,
        imageURL: imageURL ?? this.imageURL,
        description: description ?? this.description,
        shortDescription: shortDescription ?? this.shortDescription,
        tncURL: tncURL ?? this.tncURL,
        tncText: tncText ?? this.tncText,
        status: status ?? this.status,
        merchant: merchant ?? this.merchant,
        rules: rules ?? this.rules,
        type: type ?? this.type,
        currency: currency ?? this.currency,
      );

  @override
  List<Object?> get props => [
        id,
        consoleName,
        customerName,
        starts,
        ends,
        imageURL,
        description,
        shortDescription,
        tncURL,
        tncText,
        status,
        merchant,
        rules,
        type,
        currency,
      ];
}
