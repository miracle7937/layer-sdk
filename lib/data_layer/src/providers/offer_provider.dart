import '../../network.dart';
import '../dtos.dart';

/// A provider that handles API requests related to [OfferDTO].
class OfferProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  ///Creates a new [OfferProvider]
  const OfferProvider({
    required this.netClient,
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
  Future<OfferResponseDTO> list({
    List<int>? ids,
    bool isForMe = false,
    bool isFavorites = false,
    RewardTypeDTO? rewardType,
    int limit = 50,
    int offset = 0,
    DateTime? from,
    DateTime? to,
    List<int>? categories,
    bool forceRefresh = false,
    double? latitudeForDistance,
    double? longitudeForDistance,
    double? latitude,
    double? longitude,
  }) async {
    assert((!isForMe && !isFavorites) || (isForMe != isFavorites));
    assert((latitudeForDistance == null && longitudeForDistance == null) ||
        (latitudeForDistance != null && longitudeForDistance != null));

    final response = await netClient.request(
      netClient.netEndpoints.offers,
      method: NetRequestMethods.get,
      queryParameters: {
        if (ids != null && ids.isNotEmpty) 'offer_ids': ids.join(','),
        if (isForMe) 'for_me': true,
        if (isFavorites) 'favorites': true,
        if (rewardType != null) 'reward_type': rewardType.value,
        'limit': limit,
        'offset': offset,
        if (from != null) 'ts_start_after': from.millisecondsSinceEpoch,
        if (to != null) 'ts_end_before': to.millisecondsSinceEpoch,
        if (categories?.isNotEmpty ?? false)
          'category_ids': categories!.join(','),
        if (latitudeForDistance != null && longitudeForDistance != null) ...{
          'latitude_for_distance': latitudeForDistance,
          'longitude_for_distance': longitudeForDistance,
          'latitude': latitude ?? latitudeForDistance,
          'longitude': longitude ?? longitudeForDistance,
        }
      },
      forceRefresh: forceRefresh,
    );

    return OfferResponseDTO.fromJson(response.data);
  }

  ///Gets an Offer by its id.
  ///
  /// The [latitudeForDistance] and the [longitudeForDistance] fields are used
  /// for calculating the offer's distance.
  Future<OfferDTO> getOffer({
    required int id,
    bool forceRefresh = false,
    double? latitudeForDistance,
    double? longitudeForDistance,
  }) async {
    assert((latitudeForDistance == null && longitudeForDistance == null) ||
        (latitudeForDistance != null && longitudeForDistance != null));

    final response = await netClient.request(
      '${netClient.netEndpoints.offers}/$id',
      method: NetRequestMethods.get,
      queryParameters: {
        if (latitudeForDistance != null && longitudeForDistance != null) ...{
          'latitude_for_distance': latitudeForDistance,
          'longitude_for_distance': longitudeForDistance,
          'latitude': latitudeForDistance,
          'longitude': longitudeForDistance,
        }
      },
      forceRefresh: forceRefresh,
    );

    return OfferDTO.fromJson(response.data);
  }
}
