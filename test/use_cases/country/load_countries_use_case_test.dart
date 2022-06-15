import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockCountryRepository extends Mock implements CountryRepositoryInterface {
}

void main() {
  EquatableConfig.stringify = true;

  late MockCountryRepository _repository;
  late LoadCountriesUseCase _loadCountriesUseCase;

  final _mockedCountries = List.generate(3, (index) {
    return Country();
  });

  setUp(() {
    _repository = MockCountryRepository();
    _loadCountriesUseCase = LoadCountriesUseCase(repository: _repository);

    when(() => _loadCountriesUseCase()).thenAnswer(
      (_) async => _mockedCountries,
    );
  });

  test('Should return a list of Countries', () async {
    final response = await _loadCountriesUseCase();

    expect(response, _mockedCountries);

    verify(() => _repository.list());

    verifyNoMoreInteractions(_repository);
  });
}
