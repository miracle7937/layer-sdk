import 'package:equatable/equatable.dart';

/// A model representing a result of the server OCRA challenge.
class OcraChallengeResult extends Equatable {
  /// The device identifier.
  final int deviceId;

  /// The solved result to the OCRA challenge received from the server.
  final String result;

  /// Creates new [OcraChallengeResult].
  const OcraChallengeResult({
    required this.deviceId,
    required this.result,
  });

  @override
  List<Object?> get props => [
        deviceId,
        result,
      ];
}
