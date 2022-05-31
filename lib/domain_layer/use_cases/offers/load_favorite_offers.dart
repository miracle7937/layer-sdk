import '../../abstract_repositories.dart';
import '../../models.dart';
import '../../use_cases.dart';

/// Use case for loading favorite offers.
class LoadFavoriteOffers extends LoadOffers {
  final OffersRepositoryInterface _repository;

  /// Creates a new [LoadFavoriteOffers] use case.
  LoadFavoriteOffers({
    required OffersRepositoryInterface repository,
  })  : _repository = repository,
        super(repository: repository);

  /// Returns an offer response containing a list of favorite offers.
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
