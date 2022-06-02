import '../../../models.dart';

/// An abstract repository for the offers.
abstract class OffersRepositoryInterface {
  /// Paginates a list of the offers.
  Future<OfferResponse> list({
    List<int>? ids,
    bool isForMe,
    bool isFavorites,
    RewardType? rewardType,
    int? limit,
    int? offset,
    DateTime? from,
    DateTime? to,
    List<int>? categories,
    bool forceRefresh,
    double? latitudeForDistance,
    double? longitudeForDistance,
    double? latitude,
    double? longitude,
  });

  /// Gets an [Offer] by its id.
  Future<Offer> getOffer({
    required int id,
    bool forceRefresh,
    double? latitudeForDistance,
    double? longitudeForDistance,
  });
}
