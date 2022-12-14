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

///The offer Terms&Conditions type
enum TermsAndConditionsType {
  ///Path
  path,

  ///Text
  text,
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

  ///The terms and conditions plain text
  final TermsAndConditionsType? tncType;

  ///The terms and conditions. URL or Text, depending on [tncType]
  final String? tnc;

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

  ///When the merchant was created
  final DateTime? created;

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
    this.tnc,
    this.tncType,
    required this.status,
    required this.merchant,
    Iterable<OfferRule>? rules,
    required this.type,
    this.currency,
    this.created,
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
    String? tnc,
    TermsAndConditionsType? tncType,
    OfferStatus? status,
    Merchant? merchant,
    Iterable<OfferRule>? rules,
    OfferType? type,
    String? currency,
    DateTime? created,
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
        tnc: tnc ?? this.tnc,
        tncType: tncType ?? this.tncType,
        status: status ?? this.status,
        merchant: merchant ?? this.merchant,
        rules: rules ?? this.rules,
        type: type ?? this.type,
        currency: currency ?? this.currency,
        created: created ?? this.created,
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
        tnc,
        tncType,
        status,
        merchant,
        rules,
        type,
        currency,
        created,
      ];
}
