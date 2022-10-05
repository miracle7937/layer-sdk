import '../../abstract_repositories.dart';

/// Use case to delete the alert
class MarkAllAlertsAsReadUseCase {
  final ActivityRepositoryInterface _repository;

  /// Creates a new [MarkAllAlertsAsReadUseCase] instance
  MarkAllAlertsAsReadUseCase({
    required ActivityRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to read all the alerts
  Future<void> call() {
    return Future.wait([
      _repository.markAllAlertsAsRead(),
      _repository.markAllRequestsAsRead(),
    ]);
  }
}
