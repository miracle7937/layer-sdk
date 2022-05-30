import 'package:equatable/equatable.dart';

import '../../models.dart';

/// A model representing data returned after calling the
/// branch activation endpoint.
class BranchActivationResponse extends Equatable {
  /// The second factor to be used to confirm the branch activation.
  final SecondFactorVerification? secondFactorVerification;

  /// The token for submiting the second factor verification if needed or
  /// fetching the user details.
  final String? token;

  /// The device id;
  final int? deviceId;

  /// The secret key that can be used to generate a new access token using the
  /// OCRA mutual authentication flow.
  final String? ocraSecret;

  /// Creates [BranchActivationResponse].
  BranchActivationResponse({
    this.secondFactorVerification,
    this.token,
    this.deviceId,
    this.ocraSecret,
  });

  /// Returns a copy modified by provided data.
  BranchActivationResponse copyWith({
    SecondFactorVerification? secondFactorVerification,
    String? token,
    int? deviceId,
    String? ocraSecret,
  }) =>
      BranchActivationResponse(
        secondFactorVerification:
            secondFactorVerification ?? this.secondFactorVerification,
        token: token ?? this.token,
        deviceId: deviceId ?? this.deviceId,
        ocraSecret: ocraSecret ?? this.ocraSecret,
      );

  @override
  List<Object?> get props => [
        secondFactorVerification,
        token,
        deviceId,
        ocraSecret,
      ];
}
