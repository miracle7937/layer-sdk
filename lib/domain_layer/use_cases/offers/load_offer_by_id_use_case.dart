import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case that loads an offer by its id.
class LoadOfferByIdUseCase {
  final OffersRepositoryInterface _repository;

  /// Creates a new [LoadOfferByIdUseCase] use case.
  LoadOfferByIdUseCase({
    required OffersRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns the offer correspoding to the passed id.
  ///
  /// The [offerId] is required and corresponds to the offer id that you want
  /// to retrieve.
  ///
  /// The [latitude] and [longitude] values are optional and represents the
  /// current location. If indicated, the offer will be returned with the
  /// distance field filled.
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
