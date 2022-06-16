import 'package:equatable/equatable.dart';

import '../../../../../domain_layer/models.dart';
import '../../../models.dart';

/// A model representing data returned after calling the registration endpoint.
class RegistrationResponse extends Equatable {
  /// The second factor to be used to confirm the registration.
  final SecondFactorVerification? secondFactorVerification;

  /// Data of the user that will be logged in after verifying the registration.
  final User user;

  /// The secret key that can be used to generate a new access token using the
  /// OCRA mutual authentication flow.
  final String? ocraSecret;

  /// Creates [RegistrationResponse].
  RegistrationResponse({
    this.secondFactorVerification,
    required this.user,
    this.ocraSecret,
  });

  /// Returns a copy modified by provided data.
  RegistrationResponse copyWith({
    SecondFactorVerification? secondFactorVerification,
    User? user,
    String? ocraSecret,
  }) =>
      RegistrationResponse(
        secondFactorVerification:
            secondFactorVerification ?? this.secondFactorVerification,
        user: user ?? this.user,
        ocraSecret: ocraSecret ?? this.ocraSecret,
      );

  @override
  List<Object?> get props => [
        secondFactorVerification,
        user,
        ocraSecret,
      ];
}
