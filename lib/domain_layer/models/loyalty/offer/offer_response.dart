import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../models.dart';

/// A model representing data returned after calling the offers endpoint.
class OfferResponse extends Equatable {
  /// The total count of offers for the query
  final int totalCount;

  ///The list of offers
  final UnmodifiableListView<Offer> offers;

  /// Creates [OfferResponse].
  OfferResponse({
    required this.totalCount,
    required Iterable<Offer> offers,
  }) : offers = UnmodifiableListView(offers);

  /// Returns a copy modified by provided data.
  OfferResponse copyWith({
    int? totalCount,
    Iterable<Offer>? offers,
  }) =>
      OfferResponse(
        totalCount: totalCount ?? this.totalCount,
        offers: offers ?? this.offers,
      );

  @override
  List<Object?> get props => [
        totalCount,
        offers,
      ];
}
