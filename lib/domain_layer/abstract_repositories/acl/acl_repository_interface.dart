import '../../models.dart';

/// Base definition of the `ACLRepository`.
abstract class ACLRepositoryInterface {
  /// Fetches the agent `Access Control List` with the provided parameters.
  Future<List<AgentACL>> getAgentACL({
    required String userId,
    required String username,
    required String status,
  });

  /// Updates the `Access Control List` accounts of an `Agent`.
  Future<bool> updateAgentAccountVisibility({
    required List<Account> accounts,
    required Customer corporation,
    required User agent,
  });

  /// Updates the `Access Control List` cards of an `Agent`.
  Future<bool> updateAgentCardVisibility({
    required List<BankingCard> cards,
    required Customer corporation,
    required User agent,
  });
}
