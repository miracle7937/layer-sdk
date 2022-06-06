import '../../../abstract_repositories.dart';
import '../../../models.dart';
import '../../../use_cases.dart';

/// Use case for loading favorite offers.
class LoadFavoriteOffersUseCase extends LoadOffersUseCase {
  final OffersRepositoryInterface _repository;

  /// Creates a new [LoadFavoriteOffersUseCase] use case.
  LoadFavoriteOffersUseCase({
    required OffersRepositoryInterface repository,
  })  : _repository = repository,
        super(repository: repository);

  /// Returns an offer response containing a list of favorite offers.
  ///
  /// The [ids] values can be indicated to retrieve only the offers related
  /// to that list.
  ///
  /// Use the [rewardType] value for getting only the offers related to this
  /// type.
  ///
  /// [limit] and [offset] values are required for paginating the results.
  ///
  /// Use [from] and [to] values for getting only the offers inside that
  /// date range.
  ///
  /// The [categories] value is used for getting only the offers that
  /// belong to those category id list.
  ///
  /// The [latitudeForDistance] and the [longitudeForDistance] fields are used
  /// for calculating each offer's distance.
  ///
  /// When indicating the [latitudeForDistance] and the [longitudeForDistance]
  /// fields you can also indicate the [latitude] and [longitude] fields
  /// which can be used for listing the offers starting from this location.
  /// So the offers will be sorted from nearest to farthest relative to the
  /// passed distance fields.
  Future<OfferResponse> call({
    List<int>? ids,
    RewardType? rewardType,
    required int limit,
    required int offset,
    DateTime? from,
    DateTime? to,
    List<int>? categories,
    bool forceRefresh = false,
    double? latitudeForDistance,
    double? longitudeForDistance,
    double? latitude,
    double? longitude,
  }) =>
      _repository.list(
        ids: ids,
        isFavorites: true,
        rewardType: rewardType,
        limit: limit,
        offset: offset,
        from: from,
        to: to,
        categories: categories,
        forceRefresh: forceRefresh,
        latitude: latitude,
        longitude: longitude,
        latitudeForDistance: latitudeForDistance,
        longitudeForDistance: longitudeForDistance,
      );
}
