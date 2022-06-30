import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case for load branch by id
class LoadBranchByIdUseCase {
  final BranchRepositoryInterface _repository;

  /// Creates a new instance of [LoadBranchByIdUseCase]
  LoadBranchByIdUseCase({
    required BranchRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to load branch by id
  Future<Branch> call(String branchId) {
    return _repository.getBranchById(branchId);
  }
}
