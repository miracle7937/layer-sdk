import '../../abstract_repositories.dart';
import '../../models.dart';

/// An use case to request the deleting of a [User]
class DeleteAgentUseCase {
  final UserRepositoryInterface _repository;

  /// Creates a new [DeleteAgentUseCase] instance
  DeleteAgentUseCase({
    required UserRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to request the deletion of an agent.
  ///
  /// Used exclusively by the console (DBO).
  ///
  /// This request then needs to be approved by another console user.
  Future<bool> call({
    required User user,
  }) =>
      _repository.requestDeleteAgent(
        user: user,
      );
}
