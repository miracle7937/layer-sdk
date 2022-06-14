import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/experience.dart';
import 'package:mocktail/mocktail.dart';

class MockExperienceRepository extends Mock
    implements ExperienceRepositoryInterface {}

late MockExperienceRepository _repository;
late GetExperienceAndConfigureItUseCase _useCase;
late Experience _experience;

void main() {
  setUp(() {
    _repository = MockExperienceRepository();
    _useCase = GetExperienceAndConfigureItUseCase(repository: _repository);

    _experience = Experience(
      id: '1',
      menuType: ExperienceMenuType.sideDrawer,
      pages: List.generate(
        5,
        (index) => ExperiencePage(
          order: index,
          containers: List.generate(
            5,
            (index) => ExperienceContainer(
              id: index,
              name: index.toString(),
              typeCode: index.toString(),
              typeName: index.toString(),
              title: index.toString(),
              order: index,
              settings: [],
              messages: {},
            ),
          ),
        ),
      ),
    );

    when(
      () => _repository.getExperience(
        public: any(named: 'public'),
      ),
    ).thenAnswer((_) async => _experience);
  });

  test('Should return an experience', () async {
    final result = await _useCase(
      public: true,
    );

    expect(result, _experience);

    verify(
      () => _repository.getExperience(
        public: true,
      ),
    ).called(1);
  });
}
