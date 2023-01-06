/// DTO that holds the `Access Control List` of a `Agent`.
class AgentACLDTO {
  /// The user id of the agent
  final int? userId;

  /// The ACL id.
  final int? aclId;

  /// The account ID that this ACL belongs to.
  final String? accountId;

  /// The card ID that this ACL belongs to.
  final int? cardId;

  /// The status of this ACL
  final String? status;

  /// Username of the agent this ACL belongs to.
  final String? username;

  /// Creates a new [AgentACLDTO] instance.
  AgentACLDTO({
    this.userId,
    this.aclId,
    this.accountId,
    this.cardId,
    this.status,
    this.username,
  });

  /// Maps a json into a [AgentACLDTO].
  factory AgentACLDTO.fromJson(Map<String, dynamic> json) {
    return AgentACLDTO(
      userId: json['a_user_id']?.toInt(),
      aclId: json['acl_id']?.toInt(),
      accountId: json['account_id'],
      cardId: json['card_id'],
      status: json['status'],
      username: json['username'],
    );
  }

  /// Maps a json into a [AgentACLDTO].
  static List<AgentACLDTO> fromJsonList(List<Map<String, dynamic>> list) {
    return list.map(AgentACLDTO.fromJson).toList();
  }
}
