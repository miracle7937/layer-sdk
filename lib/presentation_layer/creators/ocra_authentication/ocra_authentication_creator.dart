import 'dart:math';

import 'package:ocra_authentication/ocra_authentication.dart';

import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';
import '../../widgets.dart';

/// Creator responsible for creating [OcraAuthenticationCubit].
class OcraAuthenticationCreator extends CubitCreator {
  final String _ocraSuite;
  final ClientOcraChallengeUseCase _clientChallengeOcraUseCase;
  final VerifyOcraResultUseCase _verifyOcraResultUseCase;
  final GetOcraPasswordWithBiometricsUseCase
      _getOcraPasswordWithBiometricsUseCase;

  /// Creates a new [OcraAuthenticationCreator] instance.
  OcraAuthenticationCreator({
    required String ocraSuite,
    required ClientOcraChallengeUseCase clientChallengeOcraUseCase,
    required VerifyOcraResultUseCase verifyOcraResultUseCase,
    required GetOcraPasswordWithBiometricsUseCase
        getOcraPasswordWithBiometricsUseCase,
  })  : _ocraSuite = ocraSuite,
        _clientChallengeOcraUseCase = clientChallengeOcraUseCase,
        _verifyOcraResultUseCase = verifyOcraResultUseCase,
        _getOcraPasswordWithBiometricsUseCase =
            getOcraPasswordWithBiometricsUseCase;

  /// Creates and returns an instance of the [OcraAuthenticationCubit].
  OcraAuthenticationCubit create({
    required String ocraSecret,
    required int deviceId,
  }) =>
      OcraAuthenticationCubit(
        secret: ocraSecret,
        deviceId: deviceId,
        solveOcraChallengeUseCase: SolveOcraChallengeUseCase(
          ocraAuthentication: OcraAuthentication(
            secret: ocraSecret,
            ocraSuite: _ocraSuite,
          ),
        ),
        clientChallengeOcraUseCase: _clientChallengeOcraUseCase,
        verifyOcraResultUseCase: _verifyOcraResultUseCase,
        generateOcraChallengeUseCase: GenerateOcraChallengeUseCase(
          generator: Random(),
          ocraSuite: _ocraSuite,
        ),
        generateOcraTimestampUseCase: GenerateOcraTimestampUseCase(
          ocraSuite: _ocraSuite,
        ),
        getOcraPasswordWithBiometricsUseCase:
            _getOcraPasswordWithBiometricsUseCase,
      );
}
