import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../network.dart';

/// Provider that handles API requests for the `Access Control List` endpoints.
class ACLProvider {
  /// The NetClient used for network requests.
  final NetClient netClient;

  /// Creates a new [ACLProvider] instance.
  ACLProvider({
    required this.netClient,
  });

  /// Fetches the agent `Access Control List` with the provided parameters.
  Future<List<AgentACLDTO>> getAgentACL({
    required String userId,
    required String username,
    required String status,
  }) async {
    final response = await netClient.request(
      (netClient.netEndpoints as ConsoleEndpoints).acl,
      queryParameters: {
        'a_user_id': userId,
        'status': status,
        'username': username,
      },
    );

    if (response.data is List) {
      return AgentACLDTO.fromJsonList(
        List<Map<String, dynamic>>.from(response.data),
      );
    }

    return [];
  }

  /// Updates the `Access Control List` accounts of an `Agent`.
  Future<bool> updateAgentAccountVisibility({
    required List<AccountDTO> accounts,
    required Customer corporation,
    required User agent,
  }) async {
    final corporationId = corporation.id;
    final agentUsername = agent.username;

    final response = await netClient.request(
      (netClient.netEndpoints as ConsoleEndpoints).acl,
      method: NetRequestMethods.post,
      queryParameters: {
        'customer_type': 'C',
      },
      data: {
        '$corporationId/$agentUsername': [
          {
            'customer_id': corporationId,
            'corporate_name': corporation.fullName,
            'agent_id': agent.id,
            'agent_name': agent.fullName,
          },
          ...accounts.map((e) => e.toVisibilityJson()).toList(),
        ],
      },
    );

    return response.success;
  }

  /// Updates the `Access Control List` cards of an `Agent`.
  Future<bool> updateAgentCardsVisibility({
    required List<CardDTO> cards,
    required Customer corporation,
    required User agent,
  }) async {
    final corporationId = corporation.id;
    final agentUsername = agent.username;

    final response = await netClient.request(
      (netClient.netEndpoints as ConsoleEndpoints).acl,
      method: NetRequestMethods.post,
      queryParameters: {
        'customer_type': 'C',
      },
      data: {
        '$corporationId/$agentUsername': [
          {
            'customer_id': corporationId,
            'corporate_name': corporation.fullName,
            'agent_id': agent.id,
            'agent_name': agent.fullName,
          },
          ...cards.map((e) => e.toVisibilityJson()).toList(),
        ],
      },
    );

    return response.success;
  }
}
