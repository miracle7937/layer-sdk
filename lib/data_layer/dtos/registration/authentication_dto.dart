/// Data transfer object representing data needed for
/// the registration/authentication flow (without login).
class AuthenticationDTO {
  /// An encrypted string containing any sensitive data that we need to send.
  String? encryptedCredentials;

  /// The public key used for encryption.
  String? encryptionKey;

  /// Creates [AuthenticationDTO].
  AuthenticationDTO({
    this.encryptedCredentials,
    this.encryptionKey,
  });

  /// Returns a json map.
  Map<String, dynamic> toJson() {
    return {
      'credentials': encryptedCredentials,
      'key': encryptionKey,
    };
  }
}
