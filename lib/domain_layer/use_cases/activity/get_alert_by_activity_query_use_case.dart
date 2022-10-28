import '../../abstract_repositories.dart';
import '../../models.dart';

/// The use to get the alert by the activity query
class GetAlertByActivityQueryUseCase {
  final ActivityRepositoryInterface _repository;

  /// Creates a new [GetAlertByActivityQueryUseCase]
  GetAlertByActivityQueryUseCase({
    required ActivityRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to get the alert by the activity query
  Future<Activity> call(
    String query, {
    bool? includeDetails,
  }) {
    return _repository.getAlertByActivityQuery(
      query,
      includeDetails: includeDetails,
    );
  }
}
