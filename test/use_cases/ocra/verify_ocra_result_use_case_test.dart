import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockOcraRepository extends Mock implements OcraRepositoryInterface {}

void main() {
  late MockOcraRepository ocraRepositoryMock;
  final challengeResult = OcraChallengeResult(
    deviceId: 1,
    result: 'result',
  );

  final response = OcraChallengeResultResponse();

  setUp(() {
    ocraRepositoryMock = MockOcraRepository();

    when(() => ocraRepositoryMock.verifyResult(
          result: challengeResult,
          forceRefresh: any(named: 'forceRefresh'),
        )).thenAnswer((_) async => response);
  });

  test(
    'Should return successful response',
    () async {
      final useCase = VerifyOcraResultUseCase(
        ocraRepository: ocraRepositoryMock,
      );

      final result = await useCase(result: challengeResult);

      expect(result, response);

      verify(
        () => ocraRepositoryMock.verifyResult(result: challengeResult),
      ).called(1);
    },
  );
}
