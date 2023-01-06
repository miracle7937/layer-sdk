import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case that registers corporate agents.
class RegisterCorporateAgentUseCase {
  final CorporateRegistrationRepositoryInterface _repository;

  /// Creates a new [RegisterCorporateAgentUseCase] instance.
  RegisterCorporateAgentUseCase({
    required CorporateRegistrationRepositoryInterface repository,
  }) : _repository = repository;

  /// Creates a new agent with the provided `User` information.
  Future<QueueRequest> call({
    required User user,
    bool isEditing = false,
  }) =>
      _repository.registerAgent(
        user: user,
        isEditing: isEditing,
      );
}
