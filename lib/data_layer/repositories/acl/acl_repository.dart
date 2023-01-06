import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Repository that handles `Access Control List` data.
class ACLRepository implements ACLRepositoryInterface {
  final ACLProvider _provider;

  /// Creates a new [ACLRepository] instance.
  ACLRepository({
    required ACLProvider provider,
  }) : _provider = provider;

  /// Fetches the agent `Access Control List` with the provided parameters.
  @override
  Future<List<AgentACL>> getAgentACL({
    required String userId,
    required String username,
    required String status,
  }) async {
    final dtos = await _provider.getAgentACL(
      userId: userId,
      username: username,
      status: status,
    );

    return dtos.map((e) => e.toAgentACL()).toList();
  }

  /// Updates the `Access Control List` accounts of an `Agent`.
  @override
  Future<bool> updateAgentAccountVisibility({
    required List<Account> accounts,
    required Customer corporation,
    required User agent,
  }) async =>
      _provider.updateAgentAccountVisibility(
        accounts: accounts.map((e) => e.toAccountDTO()).toList(),
        corporation: corporation,
        agent: agent,
      );

  /// Updates the `Access Control List` cards of an `Agent`.
  @override
  Future<bool> updateAgentCardVisibility({
    required List<BankingCard> cards,
    required Customer corporation,
    required User agent,
  }) async =>
      _provider.updateAgentCardsVisibility(
        cards: cards.map((e) => e.toCardDTO()).toList(),
        corporation: corporation,
        agent: agent,
      );
}
