import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/experience.dart';
import 'package:mocktail/mocktail.dart';

class MockExperienceRepository extends Mock
    implements ExperienceRepositoryInterface {}

late MockExperienceRepository _repository;
late GetExperienceAndConfigureItUseCase _useCase;
late Experience _experience;
late Experience _sortedExperience;

void main() {
  setUp(() {
    List<ExperienceContainer> _getExperienceContainers() => [
          ExperienceContainer(
            id: 1,
            name: 'container1',
            typeCode: 'container1',
            typeName: 'container1',
            title: 'container1',
            order: 3,
            settings: [],
            messages: {},
          ),
          ExperienceContainer(
            id: 2,
            name: 'container2',
            typeCode: 'container2',
            typeName: 'container2',
            title: 'container2',
            order: 1,
            settings: [],
            messages: {},
          ),
          ExperienceContainer(
            id: 3,
            name: 'container3',
            typeCode: 'container3',
            typeName: 'container3',
            title: 'container3',
            order: 2,
            settings: [],
            messages: {},
          ),
        ];

    List<ExperiencePage> _getExperiencePages() => [
          ExperiencePage(
            order: 3,
            title: 'page1',
            containers: _getExperienceContainers(),
          ),
          ExperiencePage(
            order: 1,
            title: 'page2',
            containers: _getExperienceContainers(),
          ),
          ExperiencePage(
            order: 2,
            title: 'page3',
            containers: _getExperienceContainers(),
          ),
        ];

    _repository = MockExperienceRepository();
    _useCase = GetExperienceAndConfigureItUseCase(repository: _repository);

    _experience = Experience(
      id: '1',
      menuType: ExperienceMenuType.sideDrawer,
      pages: _getExperiencePages(),
    );

    final pages = <ExperiencePage>[];
    for (var page in _experience.pages) {
      final containers = page.containers.toList();
      containers.sort((a, b) => a.order.compareTo(b.order));
      pages.add(page.copyWith(containers: containers));
    }
    pages.sort((a, b) => a.order.compareTo(b.order));
    _sortedExperience = _experience.copyWith(pages: pages);

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

    expect(result, _sortedExperience);

    verify(
      () => _repository.getExperience(
        public: true,
      ),
    ).called(1);
  });
}
