import '../../../../domain_layer/abstract_repositories.dart';
import '../../../../domain_layer/models.dart';
import '../../../mappings.dart';
import '../../../providers.dart';

/// Handles all the offers data
class OfferRepository implements OffersRepositoryInterface {
  ///The provider
  final OfferProvider provider;

  /// Creates a new repository with the supplied [OfferProvider]
  OfferRepository({
    required this.provider,
  });

  /// Lists the offers
  ///
  /// When [isForMe] is true, the returned offers will be filtered to show
  /// the offers from the `For me` tab.
  ///
  /// When [isFavorites] is true, the returned offers will be filtered to show
  /// the offers from the `Favorites` tab.
  ///
  /// The [latitudeForDistance] and the [longitudeForDistance] fields are used
  /// for calculating each offer's distance.
  ///
  /// When indicating the [latitudeForDistance] and the [longitudeForDistance]
  /// fields you can also indicate the [latitude] and [longitude] fields
  /// which can be used for listing the offers starting from this location.
  /// So the offers will be sorted from nearest to farthest relative to the
  /// passed distance fields.
  ///
  /// Use cases:
  ///   - Listing the nearest offers to the camera position in a map.
  ///
  /// When not indicated, these fields will be equal to the passed
  /// distance fields.
  @override
  Future<OfferResponse> list({
    List<int>? ids,
    bool isForMe = false,
    bool isFavorites = false,
    RewardType? rewardType,
    int? limit,
    int? offset,
    DateTime? from,
    DateTime? to,
    List<int>? categories,
    bool forceRefresh = false,
    double? latitudeForDistance,
    double? longitudeForDistance,
    double? latitude,
    double? longitude,
    String? searchQuery,
  }) async {
    assert((!isForMe && !isFavorites) || (isForMe != isFavorites));
    assert((latitudeForDistance == null && longitudeForDistance == null) ||
        (latitudeForDistance != null && longitudeForDistance != null));

    final offerResponseDTO = await provider.list(
      ids: ids,
      isForMe: isForMe,
      isFavorites: isFavorites,
      rewardType: rewardType?.toRewardTypeDTO(),
      limit: limit,
      offset: offset,
      from: from,
      to: to,
      categories: categories,
      forceRefresh: forceRefresh,
      latitudeForDistance: latitudeForDistance,
      longitudeForDistance: longitudeForDistance,
      latitude: latitude,
      longitude: longitude,
      searchQuery: searchQuery,
    );

    return offerResponseDTO.toOfferResponse();
  }

  ///Gets an Offer by its id.
  ///
  /// The [latitudeForDistance] and the [longitudeForDistance] fields are used
  /// for calculating the offer's distance.
  @override
  Future<Offer> getOffer({
    required int id,
    bool forceRefresh = false,
    double? latitudeForDistance,
    double? longitudeForDistance,
  }) async {
    assert((latitudeForDistance == null && longitudeForDistance == null) ||
        (latitudeForDistance != null && longitudeForDistance != null));

    final offerDTO = await provider.getOffer(
      id: id,
      forceRefresh: forceRefresh,
      latitudeForDistance: latitudeForDistance,
      longitudeForDistance: longitudeForDistance,
    );

    return offerDTO.toOffer();
  }
}
