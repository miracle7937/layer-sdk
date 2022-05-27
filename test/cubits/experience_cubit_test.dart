import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/business_layer/business_layer.dart';
import 'package:layer_sdk/data_layer/data_layer.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockExperienceRepository extends Mock implements ExperienceRepository {}

class MockConfigureUserExperience extends Mock
    implements ConfigureUserExperience {}

late MockExperienceRepository experienceRepositoryMock;
late MockConfigureUserExperience configureUserExperienceMock;

void main() {
  EquatableConfig.stringify = true;

  setUp(() {
    experienceRepositoryMock = MockExperienceRepository();
    configureUserExperienceMock = MockConfigureUserExperience();

    when(() => experienceRepositoryMock.getExperience(
          public: true,
          minPublicVersion: any(named: 'minPublicVersion'),
        )).thenAnswer((_) async => _experience);

    when(() => experienceRepositoryMock.getExperience(
          public: false,
          minPublicVersion: any(named: 'minPublicVersion'),
        )).thenAnswer((_) async => _experienceWithPreferences);

    when(() => experienceRepositoryMock.saveExperiencePreferences(
          experienceId: _experience.id,
          parameters: _parameters,
        )).thenAnswer((_) async => _preferences);

    when(() => configureUserExperienceMock.call(
          experience: _experience,
        )).thenAnswer((_) => _experience.pages);

    when(() => configureUserExperienceMock.call(
          experience: _newExperience,
        )).thenAnswer((_) => _newExperience.pages);

    when(() => configureUserExperienceMock.call(
          experience: _experienceWithPreferences,
        )).thenAnswer((_) => _visiblePages);
  });

  blocTest<ExperienceCubit, ExperienceState>(
    'Should start with an empty state.',
    build: () => ExperienceCubit(
      repository: experienceRepositoryMock,
      configureUserExperience: configureUserExperienceMock,
    ),
    verify: (c) => expect(
      c.state,
      ExperienceState(),
    ),
  );

  blocTest<ExperienceCubit, ExperienceState>(
    'should update the experience',
    build: () => ExperienceCubit(
      repository: experienceRepositoryMock,
      configureUserExperience: configureUserExperienceMock,
    ),
    act: (c) => c.update(experience: _newExperience),
    expect: () => [
      ExperienceState(
        experience: _newExperience,
        visiblePages: _newExperience.pages,
      ),
    ],
  );

  blocTest<ExperienceCubit, ExperienceState>(
      'Should load the public experience.',
      build: () => ExperienceCubit(
            repository: experienceRepositoryMock,
            configureUserExperience: configureUserExperienceMock,
          ),
      act: (c) => c.load(public: true),
      expect: () => [
            ExperienceState(busy: true),
            ExperienceState(
              experience: _experience,
              visiblePages: _experience.pages,
            ),
          ],
      verify: (c) {
        verify(() => experienceRepositoryMock.getExperience(
              public: true,
            )).called(1);
        verify(() => configureUserExperienceMock.call(
              experience: _experience,
            )).called(1);
      });

  blocTest<ExperienceCubit, ExperienceState>(
    'Should load the after login experience and configure user preferences',
    build: () => ExperienceCubit(
      repository: experienceRepositoryMock,
      configureUserExperience: configureUserExperienceMock,
    ),
    act: (c) => c.load(
      public: false,
    ),
    expect: () => [
      ExperienceState(busy: true),
      ExperienceState(
        experience: _experienceWithPreferences,
        visiblePages: _visiblePages,
      ),
    ],
    verify: (c) {
      verify(() => experienceRepositoryMock.getExperience(
            public: false,
          )).called(1);
      verify(() => configureUserExperienceMock.call(
            experience: _experienceWithPreferences,
          )).called(1);
    },
  );

  blocTest<ExperienceCubit, ExperienceState>(
    'Should save and configure the user experience preferences.',
    build: () => ExperienceCubit(
      repository: experienceRepositoryMock,
      configureUserExperience: configureUserExperienceMock,
    ),
    seed: () => ExperienceState(experience: _experience),
    act: (c) => c.updatePreferences(
      experienceId: _experience.id,
      parameters: _parameters,
    ),
    expect: () => [
      ExperienceState(
        experience: _experience,
        busy: true,
      ),
      ExperienceState(
        experience: _experienceWithPreferences,
        visiblePages: _visiblePages,
      ),
    ],
    verify: (c) {
      verify(() => experienceRepositoryMock.saveExperiencePreferences(
            parameters: _parameters,
            experienceId: _experience.id,
          )).called(1);
      verify(() => configureUserExperienceMock.call(
            experience: _experienceWithPreferences,
          )).called(1);
    },
  );
}

final Experience _experience = Experience(
  id: 'experienceId',
  menuType: ExperienceMenuType.tabBarBottom,
  pages: [
    ExperiencePage(
      title: 'page 1 title',
      icon: 'page 1 icon',
      order: 1,
      containers: [],
    ),
    ExperiencePage(
      title: 'page 2 title',
      icon: 'page 2 icon',
      order: 2,
      containers: [],
    ),
  ],
  colors: {
    'white': 'FFFFFF',
    'black': '000000',
  },
  fonts: {
    'body1': 'Arial',
    'body2': 'Arial',
  },
  fontSizes: {
    'body1': 12,
    'body2': 10,
  },
  backgroundImageUrl: 'backgroundImageUrl',
);

final Experience _newExperience = Experience(
  id: 'experienceId2',
  menuType: ExperienceMenuType.tabBarBottom,
  pages: [
    ExperiencePage(
      title: 'page 1 title',
      icon: 'page 1 icon',
      order: 1,
      containers: [],
    ),
    ExperiencePage(
      title: 'page 2 title',
      icon: 'page 2 icon',
      order: 2,
      containers: [],
    ),
  ],
  colors: {
    'white': 'FFFFFF',
  },
  fonts: {
    'body1': 'Arial',
  },
  fontSizes: {
    'body1': 12,
  },
  backgroundImageUrl: 'backgroundImageUrl2',
);

final Experience _experienceWithPreferences = _experience.copyWith(
  preferences: _preferences,
);

List<ExperiencePage> get _visiblePages => _experience.pages.take(1).toList();

final List<SaveExperiencePreferencesParameters> _parameters = [
  SaveExperiencePreferencesParameters(
    containerId: 'containerId',
    key: 'key',
    value: 'value',
  ),
];

final List<ExperiencePreferences> _preferences = [
  ExperiencePreferences(
    experienceId: _experience.id,
    containerPreferences: [
      ExperienceContainerPreferences(
        containerId: '1',
        preferences: <String, dynamic>{
          'pref_visibility': false,
        },
      ),
    ],
  ),
];
