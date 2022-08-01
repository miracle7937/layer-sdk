import '../../abstract_repositories.dart';

/// Use case to delete the [Activity]
class DeleteActivityUseCase {
  final ActivityRepositoryInterface _repository;

  /// Creates a new [LoadActivitiesUseCase] instance
  DeleteActivityUseCase({
    required ActivityRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable methot to delete the [Activity] by `id`
  Future<dynamic> call(String id) => _repository.delete(id);
}
