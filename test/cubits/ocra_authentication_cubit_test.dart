import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/domain_layer/errors.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:layer_sdk/features/ocra_authentication.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class GenerateOcraChallengeUseCaseMock extends Mock
    implements GenerateOcraChallengeUseCase {}

class GenerateOcraTimestampUseCaseMock extends Mock
    implements GenerateOcraTimestampUseCase {}

class ClientOcraChallengeUseCaseMock extends Mock
    implements ClientOcraChallengeUseCase {}

class VerifyOcraResultUseCaseMock extends Mock
    implements VerifyOcraResultUseCase {}

class SolveOcraChallengeUseCaseMock extends Mock
    implements SolveOcraChallengeUseCase {}

class GetOcraPasswordWithBiometricsUseCaseMock extends Mock
    implements GetOcraPasswordWithBiometricsUseCase {}

void main() {
  EquatableConfig.stringify = true;

  final secret = 'secret';
  final deviceId = 1;
  final remainingAttempts = 3;

  late GenerateOcraChallengeUseCaseMock generateOcraChallengeUseCaseMock;
  late GenerateOcraTimestampUseCaseMock generateOcraTimestampUseCaseMock;
  late ClientOcraChallengeUseCaseMock clientOcraChallengeUseCaseMock;
  late VerifyOcraResultUseCaseMock verifyOcraResultUseCaseMock;
  late SolveOcraChallengeUseCaseMock solveOcraChallengeUseCaseMock;
  late GetOcraPasswordWithBiometricsUseCaseMock
      getOcraPasswordWithBiometricsUseCaseMock;

  final successfulClientChallenge = 'successfulClientChallenge';
  final wrongPinClientChallenge = 'wrongPinClientChallenge';
  final genericFailureClientChallenge = 'genericFailureClientChallenge';
  final resultMismatchClientChallenge = 'resultMismatchClientChallenge';
  final serverChallenge = 'serverChallenge';
  final serverResponse = 'serverResponse';
  final wrongClientResult = 'wrongClientResponse';
  final wrongPinClientResult = 'wrongPinClientResult';
  final clientResponse = 'clientResponse';
  final token = 'token';
  final resultResponse = OcraChallengeResultResponse(token: token);
  final wrongPinResultResponse = OcraChallengeResultResponse(
    remainingAttempts: remainingAttempts,
  );

  final successfulOcraChallenge = OcraChallenge(
    deviceId: deviceId,
    challenge: successfulClientChallenge,
  );
  final genericFailureOcraChallenge = OcraChallenge(
    deviceId: deviceId,
    challenge: genericFailureClientChallenge,
  );
  final resultMismatchOcraChallenge = OcraChallenge(
    deviceId: deviceId,
    challenge: resultMismatchClientChallenge,
  );
  final wrongPinOcraChallenge = OcraChallenge(
    deviceId: deviceId,
    challenge: wrongPinClientChallenge,
  );

  final challengeResponse = OcraChallengeResponse(
    serverResponse: serverResponse,
    serverChallenge: serverChallenge,
  );

  final wrongPinChallengeResponse = OcraChallengeResponse(
    serverResponse: wrongPinClientResult,
    serverChallenge: serverChallenge,
  );

  final challengeResult = OcraChallengeResult(
    deviceId: deviceId,
    result: clientResponse,
  );
  final wrongPinResult = OcraChallengeResult(
    deviceId: deviceId,
    result: wrongPinClientResult,
  );

  OcraAuthenticationCubit _buildCubit() => OcraAuthenticationCubit(
        secret: secret,
        deviceId: deviceId,
        generateOcraChallengeUseCase: generateOcraChallengeUseCaseMock,
        generateOcraTimestampUseCase: generateOcraTimestampUseCaseMock,
        clientChallengeOcraUseCase: clientOcraChallengeUseCaseMock,
        verifyOcraResultUseCase: verifyOcraResultUseCaseMock,
        solveOcraChallengeUseCase: solveOcraChallengeUseCaseMock,
        getOcraPasswordWithBiometricsUseCase:
            getOcraPasswordWithBiometricsUseCaseMock,
      );

  setUp(() {
    generateOcraChallengeUseCaseMock = GenerateOcraChallengeUseCaseMock();
    generateOcraTimestampUseCaseMock = GenerateOcraTimestampUseCaseMock();
    clientOcraChallengeUseCaseMock = ClientOcraChallengeUseCaseMock();
    verifyOcraResultUseCaseMock = VerifyOcraResultUseCaseMock();
    solveOcraChallengeUseCaseMock = SolveOcraChallengeUseCaseMock();
    getOcraPasswordWithBiometricsUseCaseMock =
        GetOcraPasswordWithBiometricsUseCaseMock();

    when(
      () => clientOcraChallengeUseCaseMock(
        challenge: successfulOcraChallenge,
      ),
    ).thenAnswer((_) async => challengeResponse);

    when(
      () => clientOcraChallengeUseCaseMock(
        challenge: resultMismatchOcraChallenge,
      ),
    ).thenAnswer((_) async => challengeResponse);

    when(
      () => clientOcraChallengeUseCaseMock(challenge: wrongPinOcraChallenge),
    ).thenAnswer((_) async => wrongPinChallengeResponse);

    when(
      () => clientOcraChallengeUseCaseMock(
          challenge: genericFailureOcraChallenge),
    ).thenThrow(Exception());

    when(
      () => solveOcraChallengeUseCaseMock(
        question: successfulClientChallenge + serverChallenge,
        timestamp: any(named: 'timestamp'),
        password: any(named: 'password'),
      ),
    ).thenReturn(serverResponse);

    when(
      () => solveOcraChallengeUseCaseMock(
        question: resultMismatchClientChallenge + serverChallenge,
        timestamp: any(named: 'timestamp'),
      ),
    ).thenReturn(wrongClientResult);
    when(
      () => solveOcraChallengeUseCaseMock(
        question: wrongPinClientChallenge + serverChallenge,
        timestamp: any(named: 'timestamp'),
      ),
    ).thenReturn(wrongPinClientResult);

    when(
      () => solveOcraChallengeUseCaseMock(
        question: serverChallenge + successfulClientChallenge,
        timestamp: any(named: 'timestamp'),
        password: any(named: 'password'),
      ),
    ).thenReturn(clientResponse);

    when(
      () => solveOcraChallengeUseCaseMock(
        question: serverChallenge + wrongPinClientChallenge,
        timestamp: any(named: 'timestamp'),
      ),
    ).thenReturn(wrongPinClientResult);

    when(
      () => verifyOcraResultUseCaseMock(result: challengeResult),
    ).thenAnswer((_) async => resultResponse);

    when(
      () => verifyOcraResultUseCaseMock(result: wrongPinResult),
    ).thenAnswer((_) async => wrongPinResultResponse);
  });

  blocTest<OcraAuthenticationCubit, OcraAuthenticationState>(
    'Should start on an empty state',
    build: _buildCubit,
    verify: (c) => expect(c.state, OcraAuthenticationState()),
  );

  blocTest<OcraAuthenticationCubit, OcraAuthenticationState>(
    'Should generate a token successfully',
    build: _buildCubit,
    act: (c) {
      when(
        () => generateOcraChallengeUseCaseMock(),
      ).thenReturn(successfulClientChallenge);

      return c.generateToken();
    },
    expect: () => [
      OcraAuthenticationState(busy: true),
      OcraAuthenticationState(token: token),
    ],
    verify: (c) {
      verify(
        () => generateOcraChallengeUseCaseMock(),
      ).called(1);

      verify(
        () => solveOcraChallengeUseCaseMock(
          question: successfulClientChallenge + serverChallenge,
          timestamp: any(named: 'timestamp'),
        ),
      ).called(1);
      verify(
        () => solveOcraChallengeUseCaseMock(
          question: serverChallenge + successfulClientChallenge,
          timestamp: any(named: 'timestamp'),
        ),
      ).called(1);

      verify(
        () => clientOcraChallengeUseCaseMock(
          challenge: successfulOcraChallenge,
        ),
      ).called(1);
      verify(
        () => verifyOcraResultUseCaseMock(result: challengeResult),
      ).called(1);
    },
  );

  blocTest<OcraAuthenticationCubit, OcraAuthenticationState>(
    'Should handle a generic failure',
    build: _buildCubit,
    act: (c) {
      when(
        () => generateOcraChallengeUseCaseMock(),
      ).thenReturn(genericFailureClientChallenge);

      return c.generateToken();
    },
    expect: () => [
      OcraAuthenticationState(busy: true),
      OcraAuthenticationState(error: OcraAuthenticationError.generic),
    ],
    verify: (c) {
      verify(
        () => generateOcraChallengeUseCaseMock(),
      ).called(1);

      verifyNever(
        () => solveOcraChallengeUseCaseMock(
          question: successfulClientChallenge + serverChallenge,
          timestamp: any(named: 'timestamp'),
        ),
      );
      verifyNever(
        () => solveOcraChallengeUseCaseMock(
          question: serverChallenge + successfulClientChallenge,
          timestamp: any(named: 'timestamp'),
        ),
      );

      verify(
        () => clientOcraChallengeUseCaseMock(
          challenge: genericFailureOcraChallenge,
        ),
      ).called(1);
      verifyNever(
        () => verifyOcraResultUseCaseMock(result: challengeResult),
      );
    },
  );

  blocTest<OcraAuthenticationCubit, OcraAuthenticationState>(
    'Should handle a result mismatch',
    build: _buildCubit,
    act: (c) {
      when(
        () => generateOcraChallengeUseCaseMock(),
      ).thenReturn(resultMismatchClientChallenge);

      return c.generateToken();
    },
    expect: () => [
      OcraAuthenticationState(busy: true),
      OcraAuthenticationState(
        error: OcraAuthenticationError.serverAuthenticationFailed,
      ),
    ],
    verify: (c) {
      verify(
        () => generateOcraChallengeUseCaseMock(),
      ).called(1);

      verify(
        () => solveOcraChallengeUseCaseMock(
          question: resultMismatchClientChallenge + serverChallenge,
          timestamp: any(named: 'timestamp'),
        ),
      ).called(1);
      verifyNever(
        () => solveOcraChallengeUseCaseMock(
          question: serverChallenge + successfulClientChallenge,
          timestamp: any(named: 'timestamp'),
        ),
      );

      verify(
        () => clientOcraChallengeUseCaseMock(
          challenge: resultMismatchOcraChallenge,
        ),
      ).called(1);
      verifyNever(
        () => verifyOcraResultUseCaseMock(result: challengeResult),
      );
    },
  );

  blocTest<OcraAuthenticationCubit, OcraAuthenticationState>(
    'Should handle remaining attempts',
    build: _buildCubit,
    act: (c) {
      when(
        () => generateOcraChallengeUseCaseMock(),
      ).thenReturn(wrongPinClientChallenge);

      return c.generateToken();
    },
    expect: () => [
      OcraAuthenticationState(busy: true),
      OcraAuthenticationState(
        error: OcraAuthenticationError.wrongPin,
        remainingAttempts: remainingAttempts,
      ),
    ],
    verify: (c) {
      verify(
        () => generateOcraChallengeUseCaseMock(),
      ).called(1);

      verify(() => solveOcraChallengeUseCaseMock(
            question: wrongPinClientChallenge + serverChallenge,
            timestamp: any(named: 'timestamp'),
          )).called(1);
      verify(() => solveOcraChallengeUseCaseMock(
            question: serverChallenge + wrongPinClientChallenge,
            timestamp: any(named: 'timestamp'),
          )).called(1);

      verify(
        () => clientOcraChallengeUseCaseMock(challenge: wrongPinOcraChallenge),
      ).called(1);
      verify(
        () => verifyOcraResultUseCaseMock(result: wrongPinResult),
      ).called(1);
    },
  );

  blocTest<OcraAuthenticationCubit, OcraAuthenticationState>(
    'Should not get password with biometrics on generateToken',
    build: _buildCubit,
    act: (c) {
      when(
        () => generateOcraChallengeUseCaseMock(),
      ).thenReturn(successfulClientChallenge);

      return c.generateToken(
        getPasswordWithBiometrics: false,
      );
    },
    verify: (c) {
      verifyZeroInteractions(getOcraPasswordWithBiometricsUseCaseMock);
    },
  );

  blocTest<OcraAuthenticationCubit, OcraAuthenticationState>(
    'Should not get password with biometrics on generateClientResponse',
    build: _buildCubit,
    act: (c) {
      when(
        () => generateOcraChallengeUseCaseMock(),
      ).thenReturn(successfulClientChallenge);

      return c.generateClientResponse(
        getPasswordWithBiometrics: false,
      );
    },
    verify: (c) {
      verifyZeroInteractions(getOcraPasswordWithBiometricsUseCaseMock);
    },
  );

  blocTest<OcraAuthenticationCubit, OcraAuthenticationState>(
    'Should get password from biometrics with the correct prompt on '
    'generateToken',
    build: _buildCubit,
    act: (c) {
      when(
        () => generateOcraChallengeUseCaseMock(),
      ).thenReturn(successfulClientChallenge);
      when(
        () => getOcraPasswordWithBiometricsUseCaseMock(
          promptTitle: any(named: 'promptTitle'),
        ),
      ).thenAnswer(
        (_) async => 'password',
      );

      return c.generateToken(
        getPasswordWithBiometrics: true,
        biometricsPromptTitle: 'promptTitle',
      );
    },
    expect: () => [
      OcraAuthenticationState(busy: true),
      OcraAuthenticationState(token: token),
    ],
    verify: (c) {
      verify(
        () => getOcraPasswordWithBiometricsUseCaseMock(
          promptTitle: 'promptTitle',
        ),
      ).called(1);

      verify(
        () => solveOcraChallengeUseCaseMock(
          password: 'password',
          question: serverChallenge + successfulClientChallenge,
          timestamp: any(named: 'timestamp'),
        ),
      ).called(1);
    },
  );

  blocTest<OcraAuthenticationCubit, OcraAuthenticationState>(
    'Should get password from biometrics with the correct prompt on '
    'generateClientResponse',
    build: _buildCubit,
    act: (c) {
      when(
        () => generateOcraChallengeUseCaseMock(),
      ).thenReturn(successfulClientChallenge);
      when(
        () => getOcraPasswordWithBiometricsUseCaseMock(
          promptTitle: any(named: 'promptTitle'),
        ),
      ).thenAnswer(
        (_) async => 'password',
      );

      return c.generateClientResponse(
        getPasswordWithBiometrics: true,
        biometricsPromptTitle: 'promptTitle',
      );
    },
    expect: () => [
      OcraAuthenticationState(
        actions: {
          OcraAuthenticationAction.gettingServerChallenge,
        },
      ),
      OcraAuthenticationState(clientResponse: clientResponse),
    ],
    verify: (c) {
      verify(
        () => getOcraPasswordWithBiometricsUseCaseMock(
          promptTitle: 'promptTitle',
        ),
      ).called(1);

      verify(
        () => solveOcraChallengeUseCaseMock(
          password: 'password',
          question: serverChallenge + successfulClientChallenge,
          timestamp: any(named: 'timestamp'),
        ),
      ).called(1);
    },
  );

  blocTest<OcraAuthenticationCubit, OcraAuthenticationState>(
    'Should emit biometricsNotSupported error on generateToken',
    build: _buildCubit,
    act: (c) {
      when(
        () => getOcraPasswordWithBiometricsUseCaseMock(),
      ).thenThrow(BiometricsNotAvailableException());

      return c.generateToken(
        getPasswordWithBiometrics: true,
      );
    },
    expect: () => [
      OcraAuthenticationState(busy: true),
      OcraAuthenticationState(
        error: OcraAuthenticationError.biometricsNotSupported,
      ),
    ],
    verify: (c) {
      verify(() => getOcraPasswordWithBiometricsUseCaseMock()).called(1);
      verifyZeroInteractions(solveOcraChallengeUseCaseMock);
      verifyZeroInteractions(generateOcraChallengeUseCaseMock);
      verifyZeroInteractions(clientOcraChallengeUseCaseMock);
      verifyZeroInteractions(verifyOcraResultUseCaseMock);
    },
  );

  blocTest<OcraAuthenticationCubit, OcraAuthenticationState>(
    'Should emit biometricsNotSupported error on generateClientResponse',
    build: _buildCubit,
    act: (c) {
      when(
        () => getOcraPasswordWithBiometricsUseCaseMock(),
      ).thenThrow(BiometricsNotAvailableException());

      return c.generateClientResponse(
        getPasswordWithBiometrics: true,
      );
    },
    expect: () => [
      OcraAuthenticationState(
        actions: {
          OcraAuthenticationAction.gettingServerChallenge,
        },
      ),
      OcraAuthenticationState(
        error: OcraAuthenticationError.biometricsNotSupported,
      ),
    ],
    verify: (c) {
      verify(() => getOcraPasswordWithBiometricsUseCaseMock()).called(1);
      verifyZeroInteractions(solveOcraChallengeUseCaseMock);
      verifyZeroInteractions(generateOcraChallengeUseCaseMock);
      verifyZeroInteractions(clientOcraChallengeUseCaseMock);
      verifyZeroInteractions(verifyOcraResultUseCaseMock);
    },
  );
}
