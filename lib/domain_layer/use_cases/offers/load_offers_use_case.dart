import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case for loading all type of offers.
class LoadOffersUseCase {
  final OffersRepositoryInterface _repository;

  /// Creates a new [LoadOffersUseCase] use case.
  LoadOffersUseCase({
    required OffersRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns an offer response containing a list of offers.
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
