import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case that updates the `Access Control List` accounts of an `Agent`.
class UpdateAgentAccountVisibilityUseCase {
  final ACLRepositoryInterface _repository;

  /// Creates a new [UpdateAgentAccountVisibilityUseCase] instance.
  UpdateAgentAccountVisibilityUseCase({
    required ACLRepositoryInterface repository,
  }) : _repository = repository;

  /// Updates the `Access Control List` accounts of an `Agent`.
  Future<bool> call({
    required List<Account> accounts,
    required Customer corporation,
    required User agent,
  }) =>
      _repository.updateAgentAccountVisibility(
        accounts: accounts,
        corporation: corporation,
        agent: agent,
      );
}
