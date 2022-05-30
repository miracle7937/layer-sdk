import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/business_layer/business_layer.dart';
import 'package:layer_sdk/business_layer/src/cubits/ocra/ocra_challenge_generator.dart';
import 'package:layer_sdk/data_layer/data_layer.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ocra_authentication/ocra_authentication.dart';
import 'package:test/test.dart';

class OcraAuthenticationMock extends Mock implements OcraAuthentication {}

class OcraChallengeGeneratorMock extends Mock
    implements OcraChallengeGenerator {}

class OcraRepositoryMock extends Mock implements OcraRepository {}

void main() {
  EquatableConfig.stringify = true;

  final secret = 'secret';
  final deviceId = 1;
  final ocraSuite = 'OCRA-1:HOTP-SHA256-8:QA08-T1H';
  final remainingAttempts = 3;

  late OcraRepositoryMock repositoryMock;
  late OcraChallengeGeneratorMock ocraChallengeGeneratorMock;
  late OcraAuthenticationMock ocraAuthenticationMock;

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

  setUp(() {
    repositoryMock = OcraRepositoryMock();
    ocraChallengeGeneratorMock = OcraChallengeGeneratorMock();
    ocraAuthenticationMock = OcraAuthenticationMock();

    when(
      () => repositoryMock.challenge(challenge: successfulOcraChallenge),
    ).thenAnswer((_) async => challengeResponse);

    when(
      () => repositoryMock.challenge(challenge: resultMismatchOcraChallenge),
    ).thenAnswer((_) async => challengeResponse);

    when(
      () => repositoryMock.challenge(challenge: wrongPinOcraChallenge),
    ).thenAnswer((_) async => wrongPinChallengeResponse);

    when(
      () => repositoryMock.challenge(challenge: genericFailureOcraChallenge),
    ).thenThrow(Exception());

    when(
      () => ocraAuthenticationMock.solve(
        question: successfulClientChallenge + serverChallenge,
        timestamp: any(named: 'timestamp'),
      ),
    ).thenReturn(serverResponse);

    when(
      () => ocraAuthenticationMock.solve(
        question: resultMismatchClientChallenge + serverChallenge,
        timestamp: any(named: 'timestamp'),
      ),
    ).thenReturn(wrongClientResult);
    when(
      () => ocraAuthenticationMock.solve(
        question: wrongPinClientChallenge + serverChallenge,
        timestamp: any(named: 'timestamp'),
      ),
    ).thenReturn(wrongPinClientResult);

    when(
      () => ocraAuthenticationMock.solve(
        question: serverChallenge + successfulClientChallenge,
        timestamp: any(named: 'timestamp'),
      ),
    ).thenReturn(clientResponse);

    when(
      () => ocraAuthenticationMock.solve(
        question: serverChallenge + wrongPinClientChallenge,
        timestamp: any(named: 'timestamp'),
      ),
    ).thenReturn(wrongPinClientResult);

    when(
      () => repositoryMock.verifyResult(result: challengeResult),
    ).thenAnswer((_) async => resultResponse);

    when(
      () => repositoryMock.verifyResult(result: wrongPinResult),
    ).thenAnswer((_) async => wrongPinResultResponse);
  });

  blocTest<OcraAuthenticationCubit, OcraAuthenticationState>(
    'Should start on an empty state',
    build: () => OcraAuthenticationCubit(
      ocraSuite: ocraSuite,
      secret: secret,
      repository: repositoryMock,
      deviceId: deviceId,
      ocraAuthentication: ocraAuthenticationMock,
      challengeGenerator: ocraChallengeGeneratorMock,
    ),
    verify: (c) => expect(c.state, OcraAuthenticationState()),
  );

  blocTest<OcraAuthenticationCubit, OcraAuthenticationState>(
    'Should generate a token successfully',
    build: () => OcraAuthenticationCubit(
      ocraSuite: ocraSuite,
      secret: secret,
      repository: repositoryMock,
      deviceId: deviceId,
      ocraAuthentication: ocraAuthenticationMock,
      challengeGenerator: ocraChallengeGeneratorMock,
    ),
    act: (c) {
      when(
        () => ocraChallengeGeneratorMock.alphaNumericChallenge(8),
      ).thenReturn(successfulClientChallenge);

      return c.generateToken();
    },
    expect: () => [
      OcraAuthenticationState(busy: true),
      OcraAuthenticationState(token: token),
    ],
    verify: (c) {
      verify(
        () => ocraChallengeGeneratorMock.alphaNumericChallenge(8),
      ).called(1);

      verify(
        () => ocraAuthenticationMock.solve(
          question: successfulClientChallenge + serverChallenge,
          timestamp: any(named: 'timestamp'),
        ),
      ).called(1);
      verify(
        () => ocraAuthenticationMock.solve(
          question: serverChallenge + successfulClientChallenge,
          timestamp: any(named: 'timestamp'),
        ),
      ).called(1);

      verify(
        () => repositoryMock.challenge(challenge: successfulOcraChallenge),
      ).called(1);
      verify(
        () => repositoryMock.verifyResult(result: challengeResult),
      ).called(1);
    },
  );

  blocTest<OcraAuthenticationCubit, OcraAuthenticationState>(
    'Should handle a generic failure',
    build: () => OcraAuthenticationCubit(
      ocraSuite: ocraSuite,
      secret: secret,
      repository: repositoryMock,
      deviceId: deviceId,
      ocraAuthentication: ocraAuthenticationMock,
      challengeGenerator: ocraChallengeGeneratorMock,
    ),
    act: (c) {
      when(
        () => ocraChallengeGeneratorMock.alphaNumericChallenge(8),
      ).thenReturn(genericFailureClientChallenge);

      return c.generateToken();
    },
    expect: () => [
      OcraAuthenticationState(busy: true),
      OcraAuthenticationState(error: OcraAuthenticationError.generic),
    ],
    verify: (c) {
      verify(
        () => ocraChallengeGeneratorMock.alphaNumericChallenge(8),
      ).called(1);

      verifyNever(
        () => ocraAuthenticationMock.solve(
          question: successfulClientChallenge + serverChallenge,
          timestamp: any(named: 'timestamp'),
        ),
      );
      verifyNever(
        () => ocraAuthenticationMock.solve(
          question: serverChallenge + successfulClientChallenge,
          timestamp: any(named: 'timestamp'),
        ),
      );

      verify(
        () => repositoryMock.challenge(challenge: genericFailureOcraChallenge),
      ).called(1);
      verifyNever(
        () => repositoryMock.verifyResult(result: challengeResult),
      );
    },
  );

  blocTest<OcraAuthenticationCubit, OcraAuthenticationState>(
    'Should handle a result mismatch',
    build: () => OcraAuthenticationCubit(
      ocraSuite: ocraSuite,
      secret: secret,
      repository: repositoryMock,
      deviceId: deviceId,
      ocraAuthentication: ocraAuthenticationMock,
      challengeGenerator: ocraChallengeGeneratorMock,
    ),
    act: (c) {
      when(
        () => ocraChallengeGeneratorMock.alphaNumericChallenge(8),
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
        () => ocraChallengeGeneratorMock.alphaNumericChallenge(8),
      ).called(1);

      verify(
        () => ocraAuthenticationMock.solve(
          question: resultMismatchClientChallenge + serverChallenge,
          timestamp: any(named: 'timestamp'),
        ),
      ).called(1);
      verifyNever(
        () => ocraAuthenticationMock.solve(
          question: serverChallenge + successfulClientChallenge,
          timestamp: any(named: 'timestamp'),
        ),
      );

      verify(
        () => repositoryMock.challenge(challenge: resultMismatchOcraChallenge),
      ).called(1);
      verifyNever(
        () => repositoryMock.verifyResult(result: challengeResult),
      );
    },
  );

  blocTest<OcraAuthenticationCubit, OcraAuthenticationState>(
    'Should handle remaining attempts',
    build: () => OcraAuthenticationCubit(
      ocraSuite: ocraSuite,
      secret: secret,
      repository: repositoryMock,
      deviceId: deviceId,
      ocraAuthentication: ocraAuthenticationMock,
      challengeGenerator: ocraChallengeGeneratorMock,
    ),
    act: (c) {
      when(
        () => ocraChallengeGeneratorMock.alphaNumericChallenge(8),
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
        () => ocraChallengeGeneratorMock.alphaNumericChallenge(8),
      ).called(1);

      verify(() => ocraAuthenticationMock.solve(
            question: wrongPinClientChallenge + serverChallenge,
            timestamp: any(named: 'timestamp'),
          )).called(1);
      verify(() => ocraAuthenticationMock.solve(
            question: serverChallenge + wrongPinClientChallenge,
            timestamp: any(named: 'timestamp'),
          )).called(1);

      verify(
        () => repositoryMock.challenge(challenge: wrongPinOcraChallenge),
      ).called(1);
      verify(
        () => repositoryMock.verifyResult(result: wrongPinResult),
      ).called(1);
    },
  );
}
