import 'package:layer_sdk/_migration/business_layer/business_layer.dart';
import 'package:layer_sdk/_migration/data_layer/data_layer.dart';
import 'package:test/test.dart';

ConfigureUserExperience configureUserExperience = ConfigureUserExperience();

void main() {
  test(
    'Should filter pages by visibility and sort using preferred order',
    () {
      final pages = configureUserExperience(
        experience: _experience,
      );
      expect(pages, _expectedPages);
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
      containers: [
        ExperienceContainer(
          id: 1,
          name: 'Container 1 name',
          typeCode: 'container 1 type code',
          typeName: 'container 1 type name',
          title: 'Container 1 title',
          order: 1,
          settings: [],
          messages: {},
        ),
      ],
    ),
    ExperiencePage(
      title: 'page 2 title',
      icon: 'page 2 icon',
      order: 2,
      containers: [
        ExperienceContainer(
          id: 2,
          name: 'Container 2 name',
          typeCode: 'container 2 type code',
          typeName: 'container 2 type name',
          title: 'Container 2 title',
          order: 1,
          settings: [],
          messages: {},
        ),
        ExperienceContainer(
          id: 3,
          name: 'Container 3 name',
          typeCode: 'container 3 type code',
          typeName: 'container 3 type name',
          title: 'Container 3 title',
          order: 2,
          settings: [],
          messages: {},
        ),
      ],
    ),
  ],
  colors: {},
  fonts: {},
  fontSizes: {},
  backgroundImageUrl: 'backgroundImageUrl',
  preferences: [
    ExperiencePreferences(
      experienceId: 'experienceId',
      containerPreferences: [
        ExperienceContainerPreferences(
          containerId: '1',
          preferences: <String, dynamic>{
            'pref_visibility': false,
          },
        ),
        ExperienceContainerPreferences(
          containerId: '2',
          preferences: <String, dynamic>{
            'pref_order': 2,
          },
        ),
        ExperienceContainerPreferences(
          containerId: '3',
          preferences: <String, dynamic>{
            'pref_order': 1,
          },
        ),
      ],
    ),
  ],
);

final List<ExperiencePage> _expectedPages = [
  ExperiencePage(
    title: 'page 2 title',
    icon: 'page 2 icon',
    order: 2,
    containers: [
      ExperienceContainer(
        id: 3,
        name: 'Container 3 name',
        typeCode: 'container 3 type code',
        typeName: 'container 3 type name',
        title: 'Container 3 title',
        order: 2,
        settings: [],
        messages: {},
      ),
      ExperienceContainer(
        id: 2,
        name: 'Container 2 name',
        typeCode: 'container 2 type code',
        typeName: 'container 2 type name',
        title: 'Container 2 title',
        order: 1,
        settings: [],
        messages: {},
      ),
    ],
  ),
];
