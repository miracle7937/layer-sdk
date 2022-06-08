import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case to list branches
class LoadBranchesUseCase {
  final BranchRepositoryInterface _repository;

  /// Creates a new instance of [LoadBranchesUseCase]
  LoadBranchesUseCase({
    required BranchRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to load branches
  Future<List<Branch>> call({
    bool forceRefresh = false,
    int? limit,
    int? offset,
    double? lat,
    double? long,
    String? searchQuery,
  }) {
    return _repository.list(
      forceRefresh: forceRefresh,
      limit: limit,
      offset: offset,
      lat: lat,
      long: long,
      searchQuery: searchQuery,
    );
  }
}
