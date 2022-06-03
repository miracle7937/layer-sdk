import 'package:layer_sdk/_migration/data_layer/data_layer.dart';
import 'package:layer_sdk/_migration/data_layer/src/dtos.dart';
import 'package:layer_sdk/data_layer/network.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../utils/load_json_file.dart';

class MockExperienceProvider extends Mock implements ExperienceProvider {}

class MockUserProvider extends Mock implements UserProvider {}

class MockNetClient extends Mock implements NetClient {}

late MockExperienceProvider experienceProviderMock;
late MockUserProvider userProviderMock;
late ExperienceRepository repository;
late ExperienceDTO experienceDTO;
late MockNetClient netClientMock;

void main() {
  final dtoJson = loadJsonFile('test_resources/experience_dto.json');
  final netEndpoints = NetEndpoints();
  final user = UserDTO();

  setUp(() {
    experienceProviderMock = MockExperienceProvider();
    userProviderMock = MockUserProvider();
    repository = ExperienceRepository(
      experienceProvider: experienceProviderMock,
      userProvider: userProviderMock,
    );
    experienceDTO = ExperienceDTO.fromJson(dtoJson);
    netClientMock = MockNetClient();
    when(() => experienceProviderMock.getExperience(
          public: any(named: 'public'),
        )).thenAnswer(
      (_) async => experienceDTO,
    );
    when(() => userProviderMock.getUser(
          customerID: any(named: 'customerID'),
          forceRefresh: any(named: 'forceRefresh'),
        )).thenAnswer(
      (_) async => user,
    );
    when(() => experienceProviderMock.netClient).thenReturn(netClientMock);
    when(() => netClientMock.netEndpoints).thenReturn(netEndpoints);
  });

  test('Should sort pages.', () async {
    final experience = await repository.getExperience(public: false);

    final expectedPageOrder = ['page2', 'page3', 'page1'];
    final pageOrder = experience.pages.map((page) => page.title).toList();
    expect(pageOrder, expectedPageOrder);
  });

  test('Should sort page containers.', () async {
    final experience = await repository.getExperience(public: false);

    final expectedContainerOrder = [3, 2, 1];
    final containerOrder = experience.pages[1].containers
        .map((container) => container.id)
        .toList();
    expect(containerOrder, expectedContainerOrder);
  });

  test('Should set setting values for image settings.', () async {
    final experience = await repository.getExperience(public: false);

    final expectedSettingValues = {
      'setting1': '/infobanking/v1/image/xstudio/setting13.png',
      'setting2': '/infobanking/v1/image/xstudio/setting23.png',
    };
    final settingsWithValues = experience.pages[1].containers[0].settings
        .where((setting) => setting.value != null)
        .toList();
    final settingValues = Map.fromIterables(
      settingsWithValues.map((setting) => setting.setting),
      settingsWithValues.map((setting) => setting.value),
    );
    expect(settingValues, expectedSettingValues);
  });

  test('Should fetch the current user', () async {
    await repository.getExperience(public: false);

    verify(() => userProviderMock.getUser()).called(1);
  });

  test('Should not fetch the current user', () async {
    await repository.getExperience(public: true);

    verifyNever(() => userProviderMock.getUser());
  });
}
