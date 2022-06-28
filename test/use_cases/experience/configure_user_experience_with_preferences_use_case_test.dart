import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/experience.dart';
import 'package:mocktail/mocktail.dart';

class MockConfigureUserExperience extends Mock
    implements ConfigureUserExperienceWithPreferencesUseCase {}

late MockConfigureUserExperience configureUserExperienceMock;

void main() {
  setUp(() {
    configureUserExperienceMock = MockConfigureUserExperience();

    when(() => configureUserExperienceMock.call(
          experience: _experience,
        )).thenAnswer((_) => _experience.pages);

    when(() => configureUserExperienceMock.call(
          experience: _experienceWithPreferences,
        )).thenAnswer((_) => _visiblePages);
  });

  test('Should return the experience pages', () async {
    final result = await configureUserExperienceMock(
      experience: _experience,
    );

    expect(result, _experience.pages);

    verify(
      () => configureUserExperienceMock(
        experience: _experience,
      ),
    ).called(1);
  });

  test('Should return only the visible pages', () async {
    final result = await configureUserExperienceMock(
      experience: _experienceWithPreferences,
    );

    expect(result, _visiblePages);

    verify(
      () => configureUserExperienceMock(
        experience: _experienceWithPreferences,
      ),
    ).called(1);
  });
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

final Experience _experienceWithPreferences = _experience.copyWith(
  preferences: _preferences,
);

List<ExperiencePage> get _visiblePages => _experience.pages.take(1).toList();

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
