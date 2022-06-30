import '../../../features/user.dart';
import '../../../features/user_preferences.dart';

/// Use case that adds / removes a favorite offer from the user preferences
/// of a customer.
class ChangeOfferFavoriteStatusUseCase {
  final UserRepositoryInterface _repository;

  /// Creates a new [ChangeOfferFavoriteStatusUseCase] instance.
  ChangeOfferFavoriteStatusUseCase({
    required UserRepositoryInterface repository,
  }) : _repository = repository;

  /// Patches an user preference with different data
  Future<User> call({
    required List<int> offerIds,
  }) async =>
      _repository.patchUserPreference(
        userPreference: FavoriteOffersPreference(value: offerIds),
      );
}
