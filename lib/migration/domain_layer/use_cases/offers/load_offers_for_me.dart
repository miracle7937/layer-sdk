import '../../abstract_repositories.dart';
import '../../models.dart';
import '../../use_cases.dart';

/// Use case for loading offers for me.
class LoadOffersForMe extends LoadOffers {
  final OffersRepositoryInterface _repository;

  /// Creates a new [LoadOffersForMe] use case.
  LoadOffersForMe({
    required OffersRepositoryInterface repository,
  })  : _repository = repository,
        super(repository: repository);

  /// Returns an offer response containing a list of offers for me.
  @override
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
        isForMe: true,
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
