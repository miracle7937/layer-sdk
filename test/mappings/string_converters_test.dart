import 'package:layer_sdk/_migration/data_layer/data_layer.dart';
import 'package:test/test.dart';

void main() {
  test('toResolution tests', () {
    expect(''.toResolution(), null, reason: 'Empty string should return null.');

    expect(
      'invalid'.toResolution(),
      null,
      reason: 'Invalid string should return null.',
    );

    expect(
      '1080xBLAT'.toResolution(),
      Resolution(1080.0, 0.0),
      reason: 'Partial resolution should return zero on invalid height.',
    );

    expect(
      'x900'.toResolution(),
      Resolution(0.0, 900.0),
      reason: 'Partial resolution should return zero on invalid width.',
    );

    expect(
      '1080.0 x 2274.0'.toResolution(),
      Resolution(1080.0, 2274.0),
      reason: 'Valid string with doubles should return valid resolution.',
    );

    expect(
      '1080 x 2274'.toResolution(),
      Resolution(1080.0, 2274.0),
      reason: 'Valid string with ints should return valid resolution.',
    );
  });
}
