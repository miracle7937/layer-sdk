import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:ocra_authentication/ocra_authentication.dart';

import '../../../../../data_layer/network.dart';
import '../../../../data_layer/data_layer.dart';
import '../../cubits.dart';
import '../../errors.dart';
import '../../extensions.dart';
import 'ocra_challenge_generator.dart';

/// A cubit that provides the functionality to generate a new access token using
/// the OCRA mutual authentication flow.
///
/// The flow:
/// 1) Server and the application share a secret key. The key should be
/// exchanged only once (for example during registration) and should never leave
/// the device after that.
/// 2) The application generates a client challenge question to be solved on the
/// server side.
/// 3) The server solves the client challenge using the secret key and returns
/// the result alongside the server challenge.
/// 4) The application solves the client challenge and compares the result with
/// the result returned from the server. If the results are different then the
/// authentication must be aborted.
/// 5) The application solves the server challenge and posts the result to the
/// server.
/// 6) Server verifies the result posted by the application and returns a new
/// access token if the result is correct.
///
/// In order to use this cubit [EnvironmentConfiguration.ocraSuite] must be
/// configured.
class OcraAuthenticationCubit extends Cubit<OcraAuthenticationState> {
  final OcraAuthentication _ocraAuthentication;
  final OcraChallengeGenerator _challengeGenerator;
  final OcraRepository _repository;

  /// The device identifier.
  final int _deviceId;

  /// The configuration string for the OCRA algorithm.
  final String _ocraSuite;

  /// Creates a new [OcraAuthenticationCubit].
  ///
  /// The [ocraAuthentication] and [challengeGenerator] parameters are not
  /// meant to be passed, they are just there for unit tests.
  OcraAuthenticationCubit({
    required String secret,
    required OcraRepository repository,
    required int deviceId,
    required String ocraSuite,
    // Should not be passed outside unit tests.
    OcraAuthentication? ocraAuthentication,
    // Should not be passed outside unit tests.
    OcraChallengeGenerator? challengeGenerator,
  })  : _ocraAuthentication = ocraAuthentication ??
            OcraAuthentication(
              secret: secret,
              ocraSuite: ocraSuite,
            ),
        _deviceId = deviceId,
        _ocraSuite = ocraSuite,
        _challengeGenerator =
            challengeGenerator ?? OcraChallengeGenerator(Random()),
        _repository = repository,
        super(OcraAuthenticationState());

  /// Generates a new access token using the OCRA mutual authentication flow.
  ///
  /// The [password] parameter is optional, it needs to be provided only if it's
  /// used in the flow on the server side.
  Future<void> generateToken({String? password}) async {
    emit(
      OcraAuthenticationState(
        busy: true,
      ),
    );

    try {
      final challenge = _generateChallenge();
      final response = await _repository.challenge(
        challenge: OcraChallenge(
          deviceId: _deviceId,
          challenge: challenge,
        ),
      );

      final expectedResult = _ocraAuthentication.solve(
        question: challenge + response.serverChallenge,
        timestamp: _getTimestamp(),
      );

      if (expectedResult != response.serverResponse) {
        throw OcraWrongResultException();
      }

      final serverChallengeResult = _ocraAuthentication.solve(
        question: response.serverChallenge + challenge,
        timestamp: _getTimestamp(),
        password: password,
      );
      final resultResponse = await _repository.verifyResult(
        result: OcraChallengeResult(
          deviceId: _deviceId,
          result: serverChallengeResult,
        ),
      );

      final wrongPin = resultResponse.token == null &&
          resultResponse.remainingAttempts != null;

      emit(
        state.copyWith(
          busy: false,
          token: resultResponse.token,
          remainingAttempts: resultResponse.remainingAttempts,
          error: wrongPin
              ? OcraAuthenticationError.wrongPin
              : OcraAuthenticationError.none,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          error: e is OcraWrongResultException
              ? OcraAuthenticationError.serverAuthenticationFailed
              : e is NetException && e.statusCode == 401
                  ? OcraAuthenticationError.deviceInactive
                  : OcraAuthenticationError.generic,
        ),
      );

      rethrow;
    }
  }

  /// Returns a random question challenge generated according to the [ocraSuite]
  /// configuration.
  String _generateChallenge() {
    final type = _ocraSuite.questionType;
    final length = _ocraSuite.questionLength;
    if (type == null || length == null) {
      throw ArgumentError(
        'The provided ocra suite does not contain '
        'the challenge question specification',
      );
    }
    switch (type) {
      case 'N':
        return _challengeGenerator.numericChallenge(length);
      case 'A':
        return _challengeGenerator.alphaNumericChallenge(length);
      default:
        throw UnsupportedError(
          'Challenge question described by "$type" is not supported',
        );
    }
  }

  /// Returns the amount of time steps that passed since January 1st 1970 00:00.
  ///
  /// Returns null if the [ocraSuite] does not contain timestamp configuration.
  ///
  /// The time steps are defined in the [ocraSuite] as [1-59] seconds / minutes,
  /// [1-48] hours or a number of days.
  ///
  /// More information regarding the [ocraSuite] can be found here:
  /// https://datatracker.ietf.org/doc/html/rfc6287#section-6.3
  int? _getTimestamp() {
    final type = _ocraSuite.timestampType;
    final timeStep = _ocraSuite.timeStep;
    if (type == null || timeStep == null) {
      return null;
    }
    var divider = 1000 * timeStep;
    switch (type) {
      case 'S':
        break;
      case 'M':
        divider *= 60;
        break;
      case 'H':
        divider *= 3600;
        break;
      case 'D':
        divider *= 86400;
        break;
      default:
        throw UnsupportedError(
          'Timestamp described by "$type" is not supported',
        );
    }
    return DateTime.now().toUtc().millisecondsSinceEpoch ~/ divider;
  }
}
