import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockRandom extends Mock implements Random {}

void main() {
  late MockRandom mockRandom;

  setUp(() {
    mockRandom = MockRandom();
  });

  test(
    'Should return an alphanumeric challenge of length 9',
    () {
      final ocraSuite = 'OCRA-1:HOTP-SHA256-8:QA09-T1H-PSHA256';
      final expectedChallenge = 'cHa11enG3';
      final indices = expectedChallenge
          .split('')
          .map((e) => GenerateOcraChallengeUseCase.allowedAlphanumericCharacters
              .indexOf(e))
          .toList();

      var i = 0;
      when(() => mockRandom.nextInt(any())).thenAnswer((_) => indices[i++]);

      final useCase = GenerateOcraChallengeUseCase(
        generator: mockRandom,
        ocraSuite: ocraSuite,
      );

      final result = useCase();

      expect(result, expectedChallenge);

      verify(
        () => mockRandom.nextInt(
          GenerateOcraChallengeUseCase.allowedAlphanumericCharacters.length,
        ),
      ).called(9);
    },
  );

  test(
    'Should return a numeric challenge of length 6',
    () {
      final ocraSuite = 'OCRA-1:HOTP-SHA256-8:QN06-T1H-PSHA256';
      final expectedChallenge = '193764';
      final indices = expectedChallenge
          .split('')
          .map((e) =>
              GenerateOcraChallengeUseCase.allowedNumericCharacters.indexOf(e))
          .toList();

      var i = 0;
      when(() => mockRandom.nextInt(any())).thenAnswer((_) => indices[i++]);

      final useCase = GenerateOcraChallengeUseCase(
        generator: mockRandom,
        ocraSuite: ocraSuite,
      );

      final result = useCase();

      expect(result, expectedChallenge);

      verify(
        () => mockRandom.nextInt(
          GenerateOcraChallengeUseCase.allowedNumericCharacters.length,
        ),
      ).called(6);
    },
  );

  test(
    'Should throw an argument error',
    () {
      final ocraSuite = 'OCRA-1:HOTP-SHA256-8';

      final useCase = GenerateOcraChallengeUseCase(
        generator: mockRandom,
        ocraSuite: ocraSuite,
      );

      var errorThrown = false;

      try {
        useCase();
        // ignore: avoid_catching_errors
      } on ArgumentError {
        errorThrown = true;
      }

      expect(errorThrown, true);
    },
  );

  test(
    'Should throw an unsupported error',
    () {
      final ocraSuite = 'OCRA-1:HOTP-SHA256-8:QX06-T1H-PSHA256';

      final useCase = GenerateOcraChallengeUseCase(
        generator: mockRandom,
        ocraSuite: ocraSuite,
      );

      var errorThrown = false;

      try {
        useCase();
        // ignore: avoid_catching_errors
      } on UnsupportedError {
        errorThrown = true;
      }

      expect(errorThrown, true);
    },
  );
}
