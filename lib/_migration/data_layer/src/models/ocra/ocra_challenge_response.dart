import 'package:equatable/equatable.dart';

/// A model representing the response to the client OCRA challenge.
class OcraChallengeResponse extends Equatable {
  /// The result of the client OCRA challenge sent to the API.
  final String serverResponse;

  /// An OCRA challenge to be solved by the client.
  final String serverChallenge;

  /// Creates new [OcraChallengeResponse].
  const OcraChallengeResponse({
    required this.serverResponse,
    required this.serverChallenge,
  });

  @override
  List<Object?> get props => [
        serverResponse,
        serverChallenge,
      ];
}
