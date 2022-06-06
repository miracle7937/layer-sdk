import 'dart:async';

import '../../../abstract_repositories.dart';
import '../../../models.dart';

/// Use case for loading all loyalty points.
class LoadAllLoyaltyPointsUseCase {
  final LoyaltyPointsRepositoryInterface _repository;

  /// Creates a new [LoadAllLoyaltyPointsUseCase].
  const LoadAllLoyaltyPointsUseCase({
    required LoyaltyPointsRepositoryInterface repository,
  }) : _repository = repository;

  /// Loads all the loyalty points
  Future<List<LoyaltyPoints>> call() => _repository.listAllLoyaltyPoints();
}
