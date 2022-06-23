import '../../abstract_repositories.dart';

/// Use case to load the numbers of unread alerts
class LoadUnreadAlertsUseCase {
  final AlertRepositoryInterface _repository;

  /// Creates a new [LoadUnreadAlertsUseCase] instance
  LoadUnreadAlertsUseCase({
    required AlertRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to load the number of unread alerts
  Future<int> call({
    bool forceRefresh = false,
  }) =>
      _repository.getUnreadAlertsCount(
        forceRefresh: forceRefresh,
      );
}
