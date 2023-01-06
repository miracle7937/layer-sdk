import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use Case that loads the `Access Control List`s of a agent.
class LoadAgentACLUseCase {
  final ACLRepositoryInterface _repository;

  /// Creates a new [LoadAgentACLUseCase] instance.
  const LoadAgentACLUseCase({
    required ACLRepositoryInterface repository,
  }) : _repository = repository;

  /// Fetches the agent `Access Control List` with the provided parameters.
  Future<List<AgentACL>> call({
    required String userId,
    required String username,
    required String status,
  }) =>
      _repository.getAgentACL(
        userId: userId,
        username: username,
        status: status,
      );
}
