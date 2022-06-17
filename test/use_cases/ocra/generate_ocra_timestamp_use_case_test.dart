import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/ocra_authentication.dart';
import 'package:mocktail/mocktail.dart';

class DateTimeNowWrapperMock extends Mock implements DateTimeNowWrapper {}

void main() {
  late DateTimeNowWrapperMock nowWrapperMock;

  setUp(() {
    nowWrapperMock = DateTimeNowWrapperMock();

    when(
      () => nowWrapperMock.now(),
    ).thenReturn(DateTime(1989, 12, 31, 14, 56, 2, 20, 123));
  });

  test(
    'Should calculate the number of 10s timesteps since 1970',
    () {
      final ocraSuite = 'OCRA-1:HOTP-SHA256-8:QA08-T10S-PSHA256';
      final expectedResult = 63111576;

      final useCase = GenerateOcraTimestampUseCase(
        ocraSuite: ocraSuite,
        nowWrapper: nowWrapperMock,
      );

      final result = useCase();

      expect(result, expectedResult);
      verify(() => nowWrapperMock.now()).called(1);
    },
  );

  test(
    'Should calculate the number of 5m timesteps since 1970',
    () {
      final ocraSuite = 'OCRA-1:HOTP-SHA256-8:QA08-T5M-PSHA256';
      final expectedResult = 2103719;

      final useCase = GenerateOcraTimestampUseCase(
        ocraSuite: ocraSuite,
        nowWrapper: nowWrapperMock,
      );

      final result = useCase();

      expect(result, expectedResult);
      verify(() => nowWrapperMock.now()).called(1);
    },
  );

  test(
    'Should calculate the number of 1h timesteps since 1970',
    () {
      final ocraSuite = 'OCRA-1:HOTP-SHA256-8:QA08-T1H-PSHA256';
      final expectedResult = 175309;

      final useCase = GenerateOcraTimestampUseCase(
        ocraSuite: ocraSuite,
        nowWrapper: nowWrapperMock,
      );

      final result = useCase();

      expect(result, expectedResult);
      verify(() => nowWrapperMock.now()).called(1);
    },
  );

  test(
    'Should calculate the number of 1d timesteps since 1970',
    () {
      final ocraSuite = 'OCRA-1:HOTP-SHA256-8:QA08-T1D-PSHA256';
      final expectedResult = 7304;

      final useCase = GenerateOcraTimestampUseCase(
        ocraSuite: ocraSuite,
        nowWrapper: nowWrapperMock,
      );

      final result = useCase();

      expect(result, expectedResult);
      verify(() => nowWrapperMock.now()).called(1);
    },
  );

  test(
    'Should throw an unsupported error',
    () {
      final ocraSuite = 'OCRA-1:HOTP-SHA256-8:QA08-T1X-PSHA256';
      final useCase = GenerateOcraTimestampUseCase(
        ocraSuite: ocraSuite,
        nowWrapper: nowWrapperMock,
      );

      var errorThrown = false;

      try {
        useCase();
        // ignore: avoid_catching_errors
      } on UnsupportedError {
        errorThrown = true;
      }

      expect(errorThrown, true);
      verifyZeroInteractions(nowWrapperMock);
    },
  );
}
