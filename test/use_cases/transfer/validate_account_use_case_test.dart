import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';

void main() {
  final _validateIBANUseCase = ValidateIBANUseCase();

  test('Should return true for correctIBAN', () {
    final result = _validateIBANUseCase(iban: 'GB30PAYR00997700004655');

    expect(result, true);
  });

  test('Should return false for less than 5 chars', () {
    final result = _validateIBANUseCase(iban: 'GB30');

    expect(result, false);
  });

  test(
      'Should return false for IBAN with invalid characters '
      'with default allowedCharacters', () {
    final result = _validateIBANUseCase(iban: 'GB30PAYR00997700004655,');

    expect(result, false);
  });

  test(
      'Should return false for IBAN with invalid characters '
      'with passed allowedCharacters', () {
    final result = _validateIBANUseCase(
      iban: 'GB30PAYR00997700004655',
      allowedCharacters: 'abcedfghijklmnopqrstuvwxyz',
    );

    expect(result, false);
  });
}
