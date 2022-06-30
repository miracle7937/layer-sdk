import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/_migration/business_layer/business_layer.dart';
import 'package:layer_sdk/features/currency.dart';

late Currency _omrCurrency;
late Currency _tmpCurrency;

final _customLocale = 'pt_BR';
void main() {
  setUp(() {
    _omrCurrency = Currency(code: 'OMR', symbol: 'OMR');
    _tmpCurrency = Currency(code: 'TMP', symbol: 'TMP');

    AmountFormatter.defaultLocale = 'en_US';
  });

  test('Amount formatter tests', () async {
    expect(
      AmountFormatter.formatAmountWithCurrency(
        100.0,
        currency: _omrCurrency,
        withSymbol: true,
      ),
      'OMR100.00',
      reason: 'Format with symbol and existing currency',
    );

    expect(
      AmountFormatter.formatAmountWithCurrency(
        100.0,
        currency: _omrCurrency,
        withSymbol: true,
        decimals: 5,
      ),
      'OMR100.00000',
      reason: 'Format passing decimals',
    );

    expect(
      AmountFormatter.formatAmountWithCurrency(
        100.0,
        currency: _tmpCurrency,
        withSymbol: true,
      ),
      'TMP100.00',
      reason: 'Uses decimals from the currency',
    );

    expect(
      AmountFormatter.formatAmountWithCurrency(
        100.0,
        currency: _omrCurrency,
        withSymbol: false,
        decimals: 1,
      ),
      '100.0',
      reason: 'Format without symbol',
    );

    expect(
      AmountFormatter.formatAmountWithCurrency(
        100.0,
        withSymbol: false,
      ),
      '100.00',
      reason: 'Format without symbol and currency',
    );

    expect(
      AmountFormatter.formatAmountWithCurrency(
        100.0,
        withSymbol: false,
        decimals: 4,
      ),
      '100.0000',
      reason: 'Format with decimals and without symbol and currency',
    );
  });

  test('Locale tests', () async {
    expect(
      AmountFormatter.formatAmountWithCurrency(
        100.0,
        withSymbol: true,
      ),
      'USD100.00',
      reason: 'Use default locale',
    );

    expect(
      AmountFormatter.formatAmountWithCurrency(
        100.0,
        withSymbol: true,
        locale: _customLocale,
      ),
      'BRL\u{00A0}100,00',
      reason: 'Use custom locale',
    );

    expect(
      AmountFormatter.formatAmountWithCurrency(
        100.0,
        currency: _omrCurrency,
        withSymbol: true,
        locale: _customLocale,
        decimals: 3,
      ),
      'OMR\u{00A0}100,000',
      reason: 'Use custom locale with given currency',
    );

    expect(
      AmountFormatter.formatAmountWithCurrency(
        100.0,
        withSymbol: false,
        locale: _customLocale,
      ),
      '100,00',
      reason: 'Use custom locale with no symbol',
    );

    expect(
      AmountFormatter.formatAmountWithCurrency(
        100.0,
        withSymbol: true,
        locale: _customLocale,
        decimals: 1,
      ),
      'BRL\u{00A0}100,0',
      reason: 'Use custom locale with decimals',
    );
  });

  test('Custom pattern tests', () async {
    expect(
      AmountFormatter.formatAmountWithCurrency(
        12345.0,
        currency: _omrCurrency,
        withSymbol: true,
        customPattern: '\u00a4 #,##.#',
        decimals: 3,
      ),
      'OMR 1,23,45.000',
      reason: 'Use custom formatting',
    );

    expect(
      AmountFormatter.formatAmountWithCurrency(
        12345.0,
        withSymbol: true,
        customPattern: '\u00a4 #,##.#',
      ),
      'USD 1,23,45.00',
      reason: 'Use custom formatting with default locale',
    );

    expect(
      AmountFormatter.formatAmountWithCurrency(
        12345.0,
        withSymbol: true,
        customPattern: '\u00a4 #,##.#',
        locale: _customLocale,
      ),
      'BRL 1.23.45,00',
      reason: 'Use custom formatting with custom locale',
    );

    expect(
      AmountFormatter.formatAmountWithCurrency(
        12345.0,
        withSymbol: false,
        customPattern: '#,##.#',
        locale: _customLocale,
      ),
      '1.23.45,00',
      reason: 'Use custom formatting with custom locale and no symbol',
    );

    expect(
      AmountFormatter.formatAmountWithCurrency(
        12345.0,
        withSymbol: false,
        customPattern: '\u00a4 #,##.#',
        locale: _customLocale,
        decimals: 3,
      ),
      '1.23.45,000',
      reason: 'Use custom formatting with custom locale and decimals',
    );

    expect(
      AmountFormatter.formatAmountWithCurrency(
        12345.0,
        withSymbol: true,
        customPattern: '\u00a4 #,###.#;\u00a4 -#,###.#',
        locale: _customLocale,
        decimals: 3,
      ),
      'BRL 12.345,000',
      reason: 'Simple positive in positive/negative formats',
    );

    expect(
      AmountFormatter.formatAmountWithCurrency(
        12345.0,
        withSymbol: true,
        customPattern: '\u00a4 +#,###.#;\u00a4 -#,###.#',
        locale: _customLocale,
        decimals: 3,
      ),
      'BRL +12.345,000',
      reason: 'Positive symbol in positive/negative formats',
    );

    expect(
      AmountFormatter.formatAmountWithCurrency(
        -98765.0,
        withSymbol: true,
        customPattern: '\u00a4 #,###.#;\u00a4 -#,###.#',
        locale: _customLocale,
        decimals: 3,
      ),
      'BRL -98.765,000',
      reason: 'Negative symbol in positive/negative formats',
    );
  });
}
