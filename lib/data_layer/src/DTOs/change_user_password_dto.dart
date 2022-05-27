import '../dtos.dart';

/// The available types for the [ChangeUserPasswordDTO]
enum ChangeUserPasswordDTOType {
  /// Common bank user request (with OTP).
  user,

  /// Token request.
  token,

  /// Expired password request.
  expired,
}

/// Represents the data to be sent to the service when
/// changing bank users password.
class ChangeUserPasswordDTO {
  /// The type of request.
  final ChangeUserPasswordDTOType type;

  /// The ID of the user to be changed
  final int? userId;

  /// The username of the user to be changed
  final String? username;

  /// The old password of the user
  final String? oldPassword;

  /// The new password of the user
  final String? newPassword;

  /// The new password confirmation
  final String? confirmPassword;

  /// Creates a new [ChangeUserPasswordD]
  ChangeUserPasswordDTO({
    required this.type,
    this.userId,
    this.username,
    this.oldPassword,
    this.newPassword,
    this.confirmPassword,
  });

  /// Transforms this DTO object to a JSON map
  Map<String, dynamic> toJson() => {
        'a_user_id': userId,
        'type': type.toJson(),
        'username': username,
        'old_password': oldPassword,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      };
}

/// Holds the response data from the server.
class ChangeUserPasswordResponseDTO {
  /// If the change password was successful.
  final bool? success;

  /// If the request has a valid token.
  final bool? validToken;

  /// Information about the token.
  final String? tokenInfo;

  /// The response message.
  final String? message;

  /// The response code.
  final String? code;

  /// Data for the user that had its password changed.
  final UserDTO? user;

  /// Creates a new [ChangeUserPasswordResponseDTO].
  const ChangeUserPasswordResponseDTO({
    this.success,
    this.validToken,
    this.tokenInfo,
    this.message,
    this.code,
    this.user,
  });

  /// Creates a new [ChangeUserPasswordResponseDTO] from json
  factory ChangeUserPasswordResponseDTO.fromJson(Map<String, dynamic> json) {
    return ChangeUserPasswordResponseDTO(
      success: json['success'],
      validToken: json['valid_token'],
      tokenInfo: json['token_info'],
      message: json['message'],
      code: json['code'],
      user: json['user'] != null ? UserDTO.fromJson(json['user']) : null,
    );
  }
}

extension on ChangeUserPasswordDTOType {
  String toJson() {
    switch (this) {
      case ChangeUserPasswordDTOType.user:
        return 'U';

      case ChangeUserPasswordDTOType.token:
        return 'R';

      case ChangeUserPasswordDTOType.expired:
        return 'F';
    }
  }
}
