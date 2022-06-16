import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/experience.dart';
import 'package:mocktail/mocktail.dart';

class MockExperiencePreferencesRepository extends Mock
    implements ExperiencePreferencesRepositoryInterface {}

class MockExperiencePreferences extends Mock implements ExperiencePreferences {}

late MockExperiencePreferencesRepository _repository;
late SaveExperiencePreferencesUseCase _useCase;
late List<MockExperiencePreferences> _mockedExperiencePreferencesList;

final _experienceId = '1';
final _parameters = <SaveExperiencePreferencesParameters>[];

void main() {
  setUp(() {
    _repository = MockExperiencePreferencesRepository();
    _useCase = SaveExperiencePreferencesUseCase(repository: _repository);

    _mockedExperiencePreferencesList = List.generate(
      5,
      (index) => MockExperiencePreferences(),
    );

    when(
      () => _repository.saveExperiencePreferences(
        experienceId: any(named: 'experienceId'),
        parameters: any(named: 'parameters'),
      ),
    ).thenAnswer((_) async => _mockedExperiencePreferencesList);
  });

  test('Should return a list of experience preferences', () async {
    final result = await _useCase(
      experienceId: _experienceId,
      parameters: _parameters,
    );

    expect(result, _mockedExperiencePreferencesList);

    verify(
      () => _repository.saveExperiencePreferences(
        experienceId: _experienceId,
        parameters: _parameters,
      ),
    ).called(1);
  });
}
