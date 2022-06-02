import '../../../abstract_repositories.dart';
import '../../../models.dart';

/// Use case for loading the expired loyalty points by date.
class LoadExpiredLoyaltyPointsByDateUseCase {
  final LoyaltyPointsExpirationRepositoryInterface _repository;

  /// Creates a new [LoadExpiredLoyaltyPointsByDateUseCase].
  const LoadExpiredLoyaltyPointsByDateUseCase({
    required LoyaltyPointsExpirationRepositoryInterface repository,
  }) : _repository = repository;

  /// Loads the expired loyalty points from a date.
  Future<LoyaltyPointsExpiration> call({
    required DateTime expirationDate,
  }) =>
      _repository.getExpiryPointsByDate(expirationDate: expirationDate);
}
