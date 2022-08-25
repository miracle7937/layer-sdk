import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories/bank/bank_repository_interface.dart';
import 'package:layer_sdk/domain_layer/models/bank/bank.dart';
import 'package:layer_sdk/domain_layer/use_cases/bank/load_banks_by_country_code_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockBankRepository extends Mock implements BankRepositoryInterface {}

class MockBank extends Mock implements Bank {}

final _repository = MockBankRepository();
final _useCase = LoadBanksByCountryCodeUseCase(
  repository: _repository,
);
final _mockedBanksList = List.generate(
  10,
  (index) => MockBank(),
);

final _mockedFilteredBanksList = _mockedBanksList.take(3).toList();

final _limit = 2;
final _offset = 2;

final _mockedLimitedBanksList =
    _mockedBanksList.skip(_limit * _offset).take(_limit).toList();

final List<Bank> _mockedLimitedFilteredBanksList = [];

void main() {
  setUp(() {
    when(
      () => _repository.listByCountryCode(
        countryCode: any(named: 'countryCode'),
      ),
    ).thenAnswer((_) async => _mockedBanksList);

    when(
      () => _repository.listByCountryCode(
        countryCode: any(named: 'countryCode'),
        query: 'query',
      ),
    ).thenAnswer(
      (_) async => _mockedFilteredBanksList,
    );

    when(
      () => _repository.listByCountryCode(
        countryCode: any(named: 'countryCode'),
        limit: _limit,
        offset: _offset,
      ),
    ).thenAnswer(
      (_) async => _mockedLimitedBanksList,
    );

    when(
      () => _repository.listByCountryCode(
        countryCode: any(named: 'countryCode'),
        limit: _limit,
        offset: _offset,
        query: 'query',
      ),
    ).thenAnswer(
      (_) async => _mockedLimitedFilteredBanksList,
    );
  });

  test('Should return a list of Banks', () async {
    final result = await _useCase(countryCode: 'countryCode');

    expect(result, _mockedBanksList);

    verify(
      () => _repository.listByCountryCode(
        countryCode: any(named: 'countryCode'),
      ),
    ).called(1);
  });

  test('Should return a filtered list of Banks by searchQuery param', () async {
    final response = await _useCase(
      countryCode: 'countryCode',
      query: 'query',
    );

    expect(response, _mockedFilteredBanksList);

    verify(() => _repository.listByCountryCode(
          countryCode: any(named: 'countryCode'),
          query: any(named: 'query'),
        ));

    verifyNoMoreInteractions(_repository);
  });

  test('Should return a list of Banks with provided limit and offset',
      () async {
    final result = await _useCase(
      countryCode: 'countryCode',
      limit: _limit,
      offset: _offset,
    );

    expect(result, _mockedLimitedBanksList);

    verify(
      () => _repository.listByCountryCode(
        countryCode: any(named: 'countryCode'),
        limit: _limit,
        offset: _offset,
      ),
    ).called(1);
  });

  test(
      'Should return list of Banks  with provided limit and offset,'
      ' filtered by searchQuery param', () async {
    final response = await _useCase(
      countryCode: 'countryCode',
      limit: _limit,
      offset: _offset,
      query: 'query',
    );

    expect(response, _mockedLimitedFilteredBanksList);

    verify(() => _repository.listByCountryCode(
          countryCode: any(named: 'countryCode'),
          limit: _limit,
          offset: _offset,
          query: any(named: 'query'),
        ));

    verifyNoMoreInteractions(_repository);
  });
}
