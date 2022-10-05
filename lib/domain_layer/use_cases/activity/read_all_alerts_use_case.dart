import '../../abstract_repositories.dart';

/// Use case to delete the alert
class ReadAllAlertsUseCase {
  final ActivityRepositoryInterface _repository;

  /// Creates a new [ReadAllAlertsUseCase] instance
  ReadAllAlertsUseCase({
    required ActivityRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to read all the alerts
  Future<void> call() {
    return Future.wait([
      _repository.readAllAlerts(),
      _repository.readAllRequests(),
    ]);
  }
}
