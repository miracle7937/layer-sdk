import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case that updates the `Access Control List` cards of an `Agent`.
class UpdateAgentCardVisibilityUseCase {
  final ACLRepositoryInterface _repository;

  /// Creates a new [UpdateAgentCardVisibilityUseCase] instance.
  UpdateAgentCardVisibilityUseCase({
    required ACLRepositoryInterface repository,
  }) : _repository = repository;

  /// Updates the `Access Control List` cards of an `Agent`.
  Future<bool> call({
    required List<BankingCard> cards,
    required Customer corporation,
    required User agent,
  }) =>
      _repository.updateAgentCardVisibility(
        cards: cards,
        corporation: corporation,
        agent: agent,
      );
}
