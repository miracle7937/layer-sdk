import 'package:equatable/equatable.dart';

/// A model representing the response to the challenge result.
class OcraChallengeResultResponse extends Equatable {
  /// The newly created access token.
  final String? token;

  /// The remaining attempts before the device is deactivated.
  final int? remainingAttempts;

  /// Creates a new [OcraChallengeResultResponse].
  OcraChallengeResultResponse({
    this.token,
    this.remainingAttempts,
  });

  @override
  List<Object?> get props => [
        token,
        remainingAttempts,
      ];
}
