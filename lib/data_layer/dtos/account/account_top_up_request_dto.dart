/// Holds the account top up request data.
class AccountTopUpRequestDTO {
  /// The client secret used by the stripe sdk.
  final String? clientSecret;

  /// The ID of the top up request.
  final String? id;

  /// Creates a new [AccountTopUpRequestDTO] instance.
  const AccountTopUpRequestDTO({
    this.clientSecret,
    this.id,
  });

  /// Creates a new [AccountTopUpRequestDTO] from a json.
  factory AccountTopUpRequestDTO.fromJson(Map<String, dynamic> json) =>
      AccountTopUpRequestDTO(
        clientSecret: json['client_secret'],
        id: json['id'],
      );
}
