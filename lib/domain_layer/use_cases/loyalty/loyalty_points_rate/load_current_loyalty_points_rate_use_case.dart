import '../../../abstract_repositories.dart';
import '../../../models.dart';

/// Use case for loading the current loyalty points rate.
class LoadCurrentLoyaltyPointsRateUseCase {
  final LoyaltyPointsRateRepositoryInterface _repository;

  /// Creates a new [LoadCurrentLoyaltyPointsRateUseCase].
  const LoadCurrentLoyaltyPointsRateUseCase({
    required LoyaltyPointsRateRepositoryInterface repository,
  }) : _repository = repository;

  /// Loads the current loyalty points rate.
  Future<LoyaltyPointsRate> call({
    bool forceRefresh = false,
  }) =>
      _repository.getCurrentRate(
        forceRefesh: forceRefresh,
      );
}
