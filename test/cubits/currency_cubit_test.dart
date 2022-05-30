import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/business_layer/business_layer.dart';
import 'package:layer_sdk/data_layer/data_layer.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockCurrencyRepository extends Mock implements CurrencyRepository {}

late CurrencyRepository _repositoryMock;
late List<Currency> _currencies;
late Currency _updatedCurrency;

void main() {
  EquatableConfig.stringify = true;

  final _newCurrencies = List.generate(
    5,
    (index) => Currency(code: 'new-$index'),
  );

  _currencies = List.generate(5, (index) => Currency(code: index.toString()));
  _updatedCurrency = Currency(code: '1');

  setUp(() {
    _repositoryMock = MockCurrencyRepository();

    when(
      () => _repositoryMock.list(),
    ).thenAnswer((_) async => _currencies);

    when(
      () => _repositoryMock.getCurrencyByCode(code: '1'),
    ).thenAnswer((_) async => _updatedCurrency);
  });

  blocTest<CurrencyCubit, CurrencyState>(
    'should start on an empty state',
    build: () => CurrencyCubit(
      repository: _repositoryMock,
    ),
    verify: (c) {
      expect(c.state, CurrencyState());
    },
  );

  blocTest<CurrencyCubit, CurrencyState>(
    'should update the currencies',
    build: () => CurrencyCubit(
      repository: _repositoryMock,
    ),
    act: (c) => c.update(currencies: _newCurrencies),
    expect: () => [
      CurrencyState(currencies: _newCurrencies),
    ],
  );

  blocTest<CurrencyCubit, CurrencyState>(
    'should load currency list',
    build: () => CurrencyCubit(
      repository: _repositoryMock,
    ),
    act: (c) => c.load(),
    expect: () => [
      CurrencyState(busy: true),
      CurrencyState(currencies: _currencies),
    ],
    verify: (c) {
      verify(() => _repositoryMock.list()).called(1);
    },
  );

  blocTest<CurrencyCubit, CurrencyState>(
    'should load currency by code',
    build: () => CurrencyCubit(
      repository: _repositoryMock,
    ),
    act: (c) => c.load(code: '1'),
    expect: () => [
      CurrencyState(busy: true),
      CurrencyState(currencies: [_updatedCurrency]),
    ],
    verify: (c) {
      verify(() => _repositoryMock.getCurrencyByCode(code: '1')).called(1);
    },
  );
  blocTest<CurrencyCubit, CurrencyState>(
    'should load currency by code and updated it in the list',
    build: () => CurrencyCubit(
      repository: _repositoryMock,
    ),
    act: (c) => c.load(code: '1'),
    seed: () => CurrencyState(currencies: _currencies),
    expect: () => [
      CurrencyState(
        busy: true,
        currencies: _currencies,
      ),
      CurrencyState(
        currencies: [
          _currencies[0],
          ..._currencies.sublist(2),
          _updatedCurrency,
        ],
      ),
    ],
    verify: (c) {
      verify(() => _repositoryMock.getCurrencyByCode(code: '1')).called(1);
    },
  );

  group('FormatCurrency', _formatCurrencyTests);
}

void _formatCurrencyTests() {
  setUp(() {
    when(
      () => _repositoryMock.getCurrencyByCode(code: 'OMR'),
    ).thenAnswer(
      (_) async => Currency(
        code: 'OMR',
        decimals: 3,
        symbol: 'OMR',
      ),
    );

    when(
      () => _repositoryMock.getCurrencyByCode(code: 'TMP'),
    ).thenAnswer(
      (_) async => Currency(
        code: 'TMP',
        decimals: 1,
        symbol: 'TMP',
      ),
    );
  });

  test('Simple formatting tests', () async {
    final cubit = CurrencyCubit(repository: _repositoryMock);
    await cubit.load(code: 'OMR');
    await cubit.load(code: 'TMP');

    expect(
      cubit.formatCurrency(
        value: 100.0,
        withSymbol: true,
        currencyCode: 'OMR',
      ),
      'OMR100.000',
      reason: 'Format with symbol and existing currency',
    );

    expect(
      cubit.formatCurrency(
        value: 100.0,
        withSymbol: true,
        currencyCode: 'UNK',
      ),
      null,
      reason: 'Should return null if currency code provided but not found',
    );

    expect(
      cubit.formatCurrency(
        value: 100.0,
        withSymbol: true,
        currencyCode: 'oMr',
      ),
      'OMR100.000',
      reason: 'Format with symbol and existing currency case insensitive',
    );

    expect(
      cubit.formatCurrency(
        value: 100.0,
        withSymbol: true,
        currencyCode: 'OMR',
        decimals: 5,
      ),
      'OMR100.00000',
      reason: 'Format passing decimals',
    );

    expect(
      cubit.formatCurrency(
        value: 100.0,
        withSymbol: true,
        currencyCode: 'TMP',
      ),
      'TMP100.0',
      reason: 'Uses decimals from the currency',
    );

    expect(
      cubit.formatCurrency(
        value: 100.0,
        withSymbol: false,
        currencyCode: 'OMR',
        decimals: 1,
      ),
      '100.0',
      reason: 'Format without symbol',
    );

    expect(
      cubit.formatCurrency(
        value: 100.0,
        withSymbol: false,
      ),
      '100.00',
      reason: 'Format without symbol and currency',
    );

    expect(
      cubit.formatCurrency(
        value: 100.0,
        withSymbol: false,
        decimals: 4,
      ),
      '100.0000',
      reason: 'Format with decimals and without symbol and currency',
    );
  });

  test('Locale tests', () async {
    final cubit = CurrencyCubit(repository: _repositoryMock);
    await cubit.load(code: 'OMR');

    expect(
      cubit.formatCurrency(
        value: 100.0,
        withSymbol: true,
      ),
      'USD100.00',
      reason: 'Use default locale',
    );

    expect(
      cubit.formatCurrency(
        value: 100.0,
        withSymbol: true,
        locale: 'pt_br',
      ),
      'BRL\u{00A0}100,00',
      reason: 'Use custom locale',
    );

    expect(
      cubit.formatCurrency(
        value: 100.0,
        withSymbol: true,
        locale: 'pt_br',
        currencyCode: 'OMR',
      ),
      'OMR\u{00A0}100,000',
      reason: 'Use custom locale with given currency',
    );

    expect(
      cubit.formatCurrency(
        value: 100.0,
        withSymbol: false,
        locale: 'pt_br',
      ),
      '100,00',
      reason: 'Use custom locale with no symbol',
    );

    expect(
      cubit.formatCurrency(
        value: 100.0,
        withSymbol: true,
        locale: 'pt_br',
        decimals: 1,
      ),
      'BRL\u{00A0}100,0',
      reason: 'Use custom locale with decimals',
    );
  });

  test('Custom pattern tests', () async {
    final cubit = CurrencyCubit(repository: _repositoryMock);
    await cubit.load(code: 'OMR');

    expect(
      cubit.formatCurrency(
        value: 12345.0,
        withSymbol: true,
        currencyCode: 'OMR',
        customPattern: '\u00a4 #,##.#',
      ),
      'OMR 1,23,45.000',
      reason: 'Use custom formatting',
    );

    expect(
      cubit.formatCurrency(
        value: 12345.0,
        withSymbol: true,
        customPattern: '\u00a4 #,##.#',
      ),
      'USD 1,23,45.00',
      reason: 'Use custom formatting with default locale',
    );

    expect(
      cubit.formatCurrency(
        value: 12345.0,
        withSymbol: true,
        customPattern: '\u00a4 #,##.#',
        locale: 'pt_br',
      ),
      'BRL 1.23.45,00',
      reason: 'Use custom formatting with custom locale',
    );

    expect(
      cubit.formatCurrency(
        value: 12345.0,
        withSymbol: false,
        customPattern: '\u00a4 #,##.#',
        locale: 'pt_br',
      ),
      '1.23.45,00',
      reason: 'Use custom formatting with custom locale and no symbol',
    );

    expect(
      cubit.formatCurrency(
        value: 12345.0,
        withSymbol: false,
        customPattern: '\u00a4 #,##.#',
        locale: 'pt_br',
        decimals: 3,
      ),
      '1.23.45,000',
      reason: 'Use custom formatting with custom locale and decimals',
    );

    expect(
      cubit.formatCurrency(
        value: 12345.0,
        withSymbol: true,
        customPattern: '\u00a4 #,###.#;\u00a4 -#,###.#',
        locale: 'pt_br',
        decimals: 3,
      ),
      'BRL 12.345,000',
      reason: 'Simple positive in positive/negative formats',
    );

    expect(
      cubit.formatCurrency(
        value: 12345.0,
        withSymbol: true,
        customPattern: '\u00a4 +#,###.#;\u00a4 -#,###.#',
        locale: 'pt_br',
        decimals: 3,
      ),
      'BRL +12.345,000',
      reason: 'Positive symbol in positive/negative formats',
    );

    expect(
      cubit.formatCurrency(
        value: -98765.0,
        withSymbol: true,
        customPattern: '\u00a4 #,###.#;\u00a4 -#,###.#',
        locale: 'pt_br',
        decimals: 3,
      ),
      'BRL -98.765,000',
      reason: 'Negative symbol in positive/negative formats',
    );
  });
}
