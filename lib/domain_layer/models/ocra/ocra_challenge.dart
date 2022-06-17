import 'package:equatable/equatable.dart';

/// A model representing the client OCRA challenge.
class OcraChallenge extends Equatable {
  /// The device identifier.
  final int deviceId;

  /// The client challenge question.
  final String challenge;

  /// Creates a new [OcraChallenge].
  const OcraChallenge({
    required this.deviceId,
    required this.challenge,
  });

  @override
  List<Object?> get props => [
        deviceId,
        challenge,
      ];
}
