import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/features/currency.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockCurrencyRepository extends Mock implements CurrencyRepository {}

late CurrencyRepository _repositoryMock;
late List<Currency> _currencies;
late Currency _updatedCurrency;

late LoadAllCurrenciesUseCase _loadAllCurrenciesUseCase;
late LoadCurrencyByCodeUseCase _loadCurrencyByCodeUseCase;

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

    _loadAllCurrenciesUseCase =
        LoadAllCurrenciesUseCase(repository: _repositoryMock);
    _loadCurrencyByCodeUseCase =
        LoadCurrencyByCodeUseCase(repository: _repositoryMock);

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
      loadAllCurrenciesUseCase: _loadAllCurrenciesUseCase,
      loadCurrencyByCodeUseCase: _loadCurrencyByCodeUseCase,
    ),
    verify: (c) {
      expect(c.state, CurrencyState());
    },
  );

  blocTest<CurrencyCubit, CurrencyState>(
    'should update the currencies',
    build: () => CurrencyCubit(
      loadAllCurrenciesUseCase: _loadAllCurrenciesUseCase,
      loadCurrencyByCodeUseCase: _loadCurrencyByCodeUseCase,
    ),
    act: (c) => c.update(currencies: _newCurrencies),
    expect: () => [
      CurrencyState(currencies: _newCurrencies),
    ],
  );

  blocTest<CurrencyCubit, CurrencyState>(
    'should load currency list',
    build: () => CurrencyCubit(
      loadAllCurrenciesUseCase: _loadAllCurrenciesUseCase,
      loadCurrencyByCodeUseCase: _loadCurrencyByCodeUseCase,
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
      loadAllCurrenciesUseCase: _loadAllCurrenciesUseCase,
      loadCurrencyByCodeUseCase: _loadCurrencyByCodeUseCase,
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
      loadAllCurrenciesUseCase: _loadAllCurrenciesUseCase,
      loadCurrencyByCodeUseCase: _loadCurrencyByCodeUseCase,
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
}
