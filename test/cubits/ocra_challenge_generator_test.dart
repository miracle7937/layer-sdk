import 'dart:math';

import 'package:layer_sdk/_migration/business_layer/src/cubits/ocra/ocra_challenge_generator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockRandom extends Mock implements Random {}

final _random = MockRandom();
final _generator = OcraChallengeGenerator(_random);

void main() {
  group('Numeric Challenge Tests', _numericTests);
  group('AlphaNumeric Challenge Tests', _alphaNumericTests);
}

void _numericTests() {
  test('Simple test', () async {
    when(() => _random.nextInt(10)).thenReturn(3);
    expect(
      _generator.numericChallenge(3),
      '444',
    );
    verify(() => _random.nextInt(10)).called(3);
  });

  test('Mock random test', () async {
    final values = [3, 1, 5, 4];
    var index = 0;
    when(() => _random.nextInt(10)).thenAnswer((_) => values[index++]);
    expect(
      _generator.numericChallenge(4),
      '4265',
    );
    verify(() => _random.nextInt(10)).called(4);
  });
}

void _alphaNumericTests() {
  test('Simple test', () async {
    when(() => _random.nextInt(62)).thenReturn(10);
    expect(
      _generator.alphaNumericChallenge(10),
      'AAAAAAAAAA',
    );
    verify(() => _random.nextInt(62)).called(10);
  });

  test('Mock random test', () async {
    final values = [8, 2, 3, 3];
    var index = 0;
    when(() => _random.nextInt(62)).thenAnswer((_) => values[index++]);
    expect(
      _generator.alphaNumericChallenge(4),
      '9344',
    );
    verify(() => _random.nextInt(62)).called(4);
  });
}
