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
    required bool includeDetails,
  }) {
    final queryList = query.split('=');

    final extraParams = {queryList.first: queryList.last};

    return _repository.getAlertByActivityQuery(
      extraParams,
      includeDetails: includeDetails,
    );
  }
}
