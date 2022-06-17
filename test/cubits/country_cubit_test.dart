import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/data_layer/network.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:layer_sdk/presentation_layer/cubits.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

class MockLoadCountriesUseCase extends Mock implements LoadCountriesUseCase {}

void main() {
  EquatableConfig.stringify = true;

  late MockLoadCountriesUseCase _loadCountriesUseCase;
  late CountryCubit _cubit;

  final _mockedCountries = List.generate(
    3,
    (index) => Country(),
  );

  setUp(() {
    _loadCountriesUseCase = MockLoadCountriesUseCase();
    _cubit = CountryCubit(loadCountriesUseCase: _loadCountriesUseCase);

    when(
      () => _loadCountriesUseCase(
        registration: true,
        forceRefresh: true,
      ),
    ).thenAnswer((_) async => _mockedCountries);

    when(
      () => _loadCountriesUseCase(
        registration: false,
        forceRefresh: false,
      ),
    ).thenThrow(
      Exception('Some error'),
    );

    when(
      () => _loadCountriesUseCase(
        forceRefresh: true,
        registration: false,
      ),
    ).thenThrow(
      NetException(),
    );
  });

  blocTest<CountryCubit, CountryState>(
    'Starts with empty state',
    build: () => _cubit,
    verify: (c) => expect(
      c.state,
      CountryState(
        countries: [],
        busy: false,
        error: CountriesErrorStatus.none,
      ),
    ),
  );

  blocTest<CountryCubit, CountryState>(
    'Load method return a list of countries',
    build: () => _cubit,
    act: (c) => c.load(forceRefresh: true, registration: true),
    expect: () => [
      CountryState(
        busy: true,
        error: CountriesErrorStatus.none,
      ),
      CountryState(
        busy: false,
        error: CountriesErrorStatus.none,
        countries: _mockedCountries,
      ),
    ],
    verify: (c) {
      verify(
        () => _loadCountriesUseCase(
          registration: true,
          forceRefresh: true,
        ),
      ).called(1);
    },
  );

  blocTest<CountryCubit, CountryState>(
    'Load method return a generic error',
    build: () => _cubit,
    act: (c) => c.load(forceRefresh: false, registration: false),
    expect: () => [
      CountryState(
        busy: true,
        error: CountriesErrorStatus.none,
      ),
      CountryState(
        busy: false,
        error: CountriesErrorStatus.generic,
        countries: [],
      ),
    ],
    errors: () => [
      isA<Exception>(),
    ],
    verify: (c) {
      verify(
        () => _loadCountriesUseCase(
          registration: false,
          forceRefresh: false,
        ),
      ).called(1);
    },
  );

  blocTest<CountryCubit, CountryState>(
    'Load method return a network error',
    build: () => _cubit,
    act: (c) => c.load(forceRefresh: true, registration: false),
    expect: () => [
      CountryState(
        busy: true,
        error: CountriesErrorStatus.none,
      ),
      CountryState(
        busy: false,
        error: CountriesErrorStatus.network,
        countries: [],
      ),
    ],
    errors: () => [
      isA<Exception>(),
    ],
    verify: (c) {
      verify(
        () => _loadCountriesUseCase(
          forceRefresh: true,
          registration: false,
        ),
      ).called(1);
    },
  );
}
