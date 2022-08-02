import '../../abstract_repositories.dart';

/// Use case to delete the [Activity]
class DeleteActivityUseCase {
  final ActivityRepositoryInterface _repository;

  /// Creates a new [DeleteActivityUseCase] instance
  DeleteActivityUseCase({
    required ActivityRepositoryInterface repository,
  }) : _repository = repository;

  /// A method to call to delete an activity based on the activity
  /// request_id ([Activity.id])
  Future<void> call(String activityId) => _repository.delete(activityId);
}
