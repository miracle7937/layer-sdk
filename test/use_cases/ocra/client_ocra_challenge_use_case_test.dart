import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockOcraRepository extends Mock implements OcraRepositoryInterface {}

void main() {
  late MockOcraRepository ocraRepositoryMock;
  final challenge = OcraChallenge(
    deviceId: 1,
    challenge: 'challenge',
  );

  final response = OcraChallengeResponse(
    serverResponse: 'serverResponse',
    serverChallenge: 'serverChallenge',
  );

  setUp(() {
    ocraRepositoryMock = MockOcraRepository();

    when(() => ocraRepositoryMock.challenge(
          challenge: challenge,
          forceRefresh: any(named: 'forceRefresh'),
        )).thenAnswer((_) async => response);
  });

  test(
    'Should return challenge response',
    () async {
      final useCase = ClientOcraChallengeUseCase(
        ocraRepository: ocraRepositoryMock,
      );

      final result = await useCase(challenge: challenge);

      expect(result, response);

      verify(
        () => ocraRepositoryMock.challenge(challenge: challenge),
      ).called(1);
    },
  );
}
