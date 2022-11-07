import '../../abstract_repositories.dart';

/// Use case to delete the alert
class DeleteAllAlertsUseCase {
  final ActivityRepositoryInterface _repository;

  /// Creates a new [DeleteAllAlertsUseCase] instance
  DeleteAllAlertsUseCase({
    required ActivityRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to delete all the alerts
  Future<void> call() {
    return Future.wait([
      _repository.deleteAllAlerts(),
      _repository.deleteAllRequests(),
    ]);
  }
}
