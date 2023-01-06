import 'package:equatable/equatable.dart';

/// Model that holds the `Access Control List` of a `Agent`.
class AgentACL extends Equatable {
  /// The user id of the agent
  final int userId;

  /// The ACL id.
  final int aclId;

  /// The account ID that this ACL belongs to.
  final String accountId;

  /// The card ID that this ACL belongs to.
  final String cardId;

  /// The status of this ACL
  final String status;

  /// Username of the agent this ACL belongs to.
  final String username;

  /// Creates a new [AgentACL] instance.
  AgentACL({
    this.userId = 0,
    this.aclId = 0,
    this.accountId = '',
    this.cardId = '',
    this.status = '',
    this.username = '',
  });

  @override
  List<Object> get props {
    return [
      userId,
      aclId,
      accountId,
      cardId,
      status,
      username,
    ];
  }

  /// Creates a copy of a [AgentACL] with the provided parameters
  AgentACL copyWith({
    int? userId,
    int? aclId,
    String? accountId,
    String? cardId,
    String? status,
    String? username,
  }) {
    return AgentACL(
      userId: userId ?? this.userId,
      aclId: aclId ?? this.aclId,
      accountId: accountId ?? this.accountId,
      cardId: cardId ?? this.cardId,
      status: status ?? this.status,
      username: username ?? this.username,
    );
  }
}
