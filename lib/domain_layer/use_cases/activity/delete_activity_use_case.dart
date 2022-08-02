import '../../abstract_repositories/activity/activity_repository_interface.dart';
import '../../models.dart';

/// The use case to delete an activity
class DeleteActivityUseCase {
  final ActivityRepositoryInterface _repository;

  /// Create new instance of [DeleteActivityUseCase]
  DeleteActivityUseCase({
    required ActivityRepositoryInterface repository,
  }) : _repository = repository;

  /// A method to call to delete an activity based on the activity
  /// request_id ([Activity.id])
  Future<void> call(String activityId) => _repository.delete(activityId);
}
