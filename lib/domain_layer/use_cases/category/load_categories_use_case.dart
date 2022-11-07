import '../../abstract_repositories.dart';
import '../../models.dart';

/// An use case to load all the categories
class LoadCategoriesUseCase {
  final CategoryRepositoryInterface _repository;

  /// Creates a new [LoadCategoriesUseCase] instance
  LoadCategoriesUseCase({
    required CategoryRepositoryInterface repository,
  }) : _repository = repository;

  ///Lists the categories
  Future<List<Category>> call({
    bool forceRefresh = false,
  }) {
    return _repository.list(forceRefresh: forceRefresh);
  }
}
