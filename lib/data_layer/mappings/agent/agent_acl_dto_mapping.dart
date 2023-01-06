import '../../../domain_layer/models.dart';
import '../../dtos.dart';

/// Extension that provides mappings for [AgentACLDTO].
extension AgentACLDTOMapping on AgentACLDTO {
  /// Maps into a [AgentACL].
  AgentACL toAgentACL() => AgentACL(
        accountId: accountId ?? '',
        aclId: aclId ?? 0,
        cardId: cardId?.toString() ?? '',
        status: status ?? '',
        userId: userId ?? 0,
        username: username ?? '',
      );
}
