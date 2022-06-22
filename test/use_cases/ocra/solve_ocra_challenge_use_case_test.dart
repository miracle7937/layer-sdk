import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ocra_authentication/ocra_authentication.dart';

class MockOcraAuthentication extends Mock implements OcraAuthentication {}

void main() {
  late MockOcraAuthentication ocraAuthenticationMock;
  final challengeResult = 'result';

  setUp(() {
    ocraAuthenticationMock = MockOcraAuthentication();

    when(() => ocraAuthenticationMock.solve(
          question: any(named: 'question'),
          counter: any(named: 'counter'),
          password: any(named: 'password'),
          sessionInformation: any(named: 'sessionInformation'),
          timestamp: any(named: 'timestamp'),
        )).thenAnswer((_) => challengeResult);
  });

  test(
    'Should return successful response',
    () async {
      final question = 'question';
      final counter = 'counter';
      final password = 'password';
      final sessionInformation = 'sessionInformation';
      final timestamp = 214;

      final useCase = SolveOcraChallengeUseCase(
        ocraAuthentication: ocraAuthenticationMock,
      );

      final result = await useCase(
        question: question,
        counter: counter,
        password: password,
        sessionInformation: sessionInformation,
        timestamp: timestamp,
      );

      expect(result, challengeResult);

      verify(
        () => ocraAuthenticationMock.solve(
          question: question,
          counter: counter,
          password: password,
          sessionInformation: sessionInformation,
          timestamp: timestamp,
        ),
      ).called(1);
    },
  );
}
