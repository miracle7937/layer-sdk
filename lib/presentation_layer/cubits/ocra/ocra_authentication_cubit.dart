import 'package:biometric_storage/biometric_storage.dart';
import 'package:bloc/bloc.dart';

import '../../../data_layer/network.dart';
import '../../../domain_layer/errors.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';
import '../../errors.dart';
import '../../extensions.dart';

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
  final GenerateOcraChallengeUseCase _generateOcraChallengeUseCase;
  final GenerateOcraTimestampUseCase _generateOcraTimestampUseCase;
  final ClientOcraChallengeUseCase _clientChallengeOcraUseCase;
  final SolveOcraChallengeUseCase _solveOcraChallengeUseCase;
  final VerifyOcraResultUseCase _verifyOcraResultUseCase;
  final GetOcraPasswordWithBiometricsUseCase?
      _getOcraPasswordWithBiometricsUseCase;

  /// The device identifier.
  final int _deviceId;

  /// Creates a new [OcraAuthenticationCubit].
  ///
  /// The [getOcraPasswordWithBiometricsUseCase] is optional, it should be
  /// passed by applications that want to use biometrics with the OCRA flow.
  OcraAuthenticationCubit({
    required String secret,
    required int deviceId,
    required SolveOcraChallengeUseCase solveOcraChallengeUseCase,
    required ClientOcraChallengeUseCase clientChallengeOcraUseCase,
    required VerifyOcraResultUseCase verifyOcraResultUseCase,
    required GenerateOcraChallengeUseCase generateOcraChallengeUseCase,
    required GenerateOcraTimestampUseCase generateOcraTimestampUseCase,
    GetOcraPasswordWithBiometricsUseCase? getOcraPasswordWithBiometricsUseCase,
  })  : _deviceId = deviceId,
        _solveOcraChallengeUseCase = solveOcraChallengeUseCase,
        _clientChallengeOcraUseCase = clientChallengeOcraUseCase,
        _verifyOcraResultUseCase = verifyOcraResultUseCase,
        _generateOcraChallengeUseCase = generateOcraChallengeUseCase,
        _generateOcraTimestampUseCase = generateOcraTimestampUseCase,
        _getOcraPasswordWithBiometricsUseCase =
            getOcraPasswordWithBiometricsUseCase,
        super(OcraAuthenticationState());

  /// Generates a new access token using the OCRA mutual authentication flow.
  ///
  /// The [password] parameter is optional, it needs to be provided only if it's
  /// used in the flow on the server side.
  ///
  /// The [password] can be retrieved from the biometrics protected storage if
  /// the [getPasswordWithBiometrics] flag is set to `true`. The flag has no
  /// effect if the [_getOcraPasswordWithBiometricsUseCase] is `null`.
  ///
  /// The [biometricsPromptTitle] can be provided to localize the title
  /// displayed in the native biometrics popup.
  Future<void> generateToken({
    String? password,
    bool getPasswordWithBiometrics = false,
    String biometricsPromptTitle = '',
    bool shouldRethrow = false,
  }) async {
    emit(
      OcraAuthenticationState(
        busy: true,
      ),
    );

    try {
      if (getPasswordWithBiometrics &&
          _getOcraPasswordWithBiometricsUseCase != null) {
        password = await _getOcraPasswordWithBiometricsUseCase!(
          promptTitle: biometricsPromptTitle,
        );
      }

      final challenge = _generateOcraChallengeUseCase();
      final timestamp = _generateOcraTimestampUseCase();
      final response = await _clientChallengeOcraUseCase(
        challenge: OcraChallenge(
          deviceId: _deviceId,
          challenge: challenge,
        ),
      );

      final expectedResult = _solveOcraChallengeUseCase(
        question: challenge + response.serverChallenge,
        timestamp: timestamp,
      );

      if (expectedResult != response.serverResponse) {
        throw OcraWrongResultException();
      }

      final serverChallengeResult = _solveOcraChallengeUseCase(
        question: response.serverChallenge + challenge,
        timestamp: timestamp,
        password: password,
      );
      final resultResponse = await _verifyOcraResultUseCase(
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
    } on BiometricsNotAvailableException catch (e, st) {
      logException(e, st);

      emit(
        state.copyWith(
          busy: false,
          error: OcraAuthenticationError.biometricsNotSupported,
        ),
      );
    } on AuthException catch (e) {
      emit(
        state.copyWith(
          busy: false,
          error: [
            AuthExceptionCode.canceled,
            AuthExceptionCode.userCanceled,
          ].contains(e.code)
              ? OcraAuthenticationError.none
              : OcraAuthenticationError.generic,
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
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

      if (shouldRethrow) {
        rethrow;
      }
    }
  }

  /// Generates a new client response to be send on
  /// 2fa request in case of biometrics
  ///
  /// The [password] can be retrieved from the biometrics protected storage if
  /// the [getPasswordWithBiometrics] flag is set to `true`. The flag has no
  /// effect if the [_getOcraPasswordWithBiometricsUseCase] is `null`.
  Future<void> generateClientResponse({
    String? password,
    bool getPasswordWithBiometrics = false,
    String biometricsPromptTitle = '',
    bool shouldRethrow = false,
  }) async {
    emit(
      state.copyWith(
        actions: state.addAction(
          OcraAuthenticationAction.gettingServerChallenge,
        ),
        errors: {},
      ),
    );

    try {
      if (getPasswordWithBiometrics &&
          _getOcraPasswordWithBiometricsUseCase != null) {
        password = await _getOcraPasswordWithBiometricsUseCase!(
          promptTitle: biometricsPromptTitle,
        );
      }

      final challenge = _generateOcraChallengeUseCase();
      final timestamp = _generateOcraTimestampUseCase();
      final response = await _clientChallengeOcraUseCase(
        challenge: OcraChallenge(
          deviceId: _deviceId,
          challenge: challenge,
        ),
      );

      final expectedResult = _solveOcraChallengeUseCase(
        question: challenge + response.serverChallenge,
        timestamp: timestamp,
      );

      if (expectedResult != response.serverResponse) {
        throw OcraWrongResultException();
      }

      final serverChallengeResult = _solveOcraChallengeUseCase(
        question: response.serverChallenge + challenge,
        timestamp: timestamp,
        password: password,
      );

      emit(
        state.copyWith(
          actions: state.removeAction(
            OcraAuthenticationAction.gettingServerChallenge,
          ),
          clientResponse: serverChallengeResult,
        ),
      );
    } on BiometricsNotAvailableException catch (e, st) {
      logException(e, st);

      emit(
        state.copyWith(
          actions: state.removeAction(
            OcraAuthenticationAction.gettingServerChallenge,
          ),
          error: OcraAuthenticationError.biometricsNotSupported,
        ),
      );
    } on AuthException catch (e) {
      emit(
        state.copyWith(
          busy: false,
          error: [
            AuthExceptionCode.canceled,
            AuthExceptionCode.userCanceled,
          ].contains(e.code)
              ? OcraAuthenticationError.none
              : OcraAuthenticationError.generic,
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          actions: state.removeAction(
            OcraAuthenticationAction.gettingServerChallenge,
          ),
          errors: state.addErrorFromException(
            action: OcraAuthenticationAction.gettingServerChallenge,
            exception: e,
          ),
        ),
      );

      if (shouldRethrow) {
        rethrow;
      }
    }
  }
}
