import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case that loads an offer by its id.
class LoadOfferById {
  final OffersRepositoryInterface _repository;

  /// Creates a new [LoadOfferById] use case.
  LoadOfferById({
    required OffersRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns the offer correspoding to the passed id.
  Future<Offer> call({
    required int offerId,
    bool forceRefresh = false,
    double? latitude,
    double? longitude,
  }) =>
      _repository.getOffer(
        id: offerId,
        forceRefresh: forceRefresh,
        latitudeForDistance: latitude,
        longitudeForDistance: longitude,
      );
}
