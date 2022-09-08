import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';

void main() {
  final _validateAccountUseCase = ValidateAccountUseCase();

  test('Should return true for correctIBAN', () {
    final result = _validateAccountUseCase(account: '75486960');

    expect(result, true);
  });

  test('Should return false for less than default minAccountChars', () {
    final result = _validateAccountUseCase(account: '75486');

    expect(result, false);
  });

  test('Should return false for more than default maxAccountChars', () {
    final result = _validateAccountUseCase(
      account: '75486960754869607548696075486960754869607548696075486960',
    );

    expect(result, false);
  });

  test(
      'Should return false for Account with invalid characters '
      'with default allowedCharacters', () {
    final result = _validateAccountUseCase(account: 'GB30PAYR00997700004655');

    expect(result, false);
  });

  test(
      'Should return false for Account with invalid characters '
      'with passed allowedCharacters', () {
    final result = _validateAccountUseCase(
      account: '75486960',
      allowedCharacters: 'abcedfghijklmnopqrstuvwxyz',
    );

    expect(result, false);
  });
}
