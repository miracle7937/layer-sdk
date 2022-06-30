import 'package:ocra_authentication/ocra_authentication.dart';

/// The use case responsible for solving the OCRA challenges.
class SolveOcraChallengeUseCase {
  final OcraAuthentication _ocraAuthentication;

  /// Creates [SolveOcraChallengeUseCase].
  SolveOcraChallengeUseCase({
    required OcraAuthentication ocraAuthentication,
  }) : _ocraAuthentication = ocraAuthentication;

  /// Returns the result for the provided challenge question and the optional
  /// parameters.
  String call({
    required String question,
    String? counter,
    String? password,
    String? sessionInformation,
    int? timestamp,
  }) =>
      _ocraAuthentication.solve(
        question: question,
        counter: counter,
        password: password,
        sessionInformation: sessionInformation,
        timestamp: timestamp,
      );
}
