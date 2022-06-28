import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/presentation_layer/extensions.dart';

void main() {
  group('capitalize', () {
    _testCapitalize('', '');
    _testCapitalize('this is a test', 'This is a test');
    _testCapitalize('tHis Is anOTHer Text', 'This is another text');
  });

  group('capitalizeSentence', () {
    _testCapitalizeSentence('', '');
    _testCapitalizeSentence('this is a test', 'This Is A Test');
    _testCapitalizeSentence('tHis Is anOTHer Text', 'This Is Another Text');
  });
}

void _testCapitalize(String input, String expected) {
  test('String: $input', () {
    expect(input.capitalize, expected);
  });
}

void _testCapitalizeSentence(String input, String expected) {
  test('String: $input', () {
    expect(input.capitalizeSentence, expected);
  });
}
