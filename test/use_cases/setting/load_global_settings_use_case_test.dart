import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories/setting/global_setting_repository_interface.dart';
import 'package:layer_sdk/domain_layer/models/setting/global_setting.dart';
import 'package:layer_sdk/domain_layer/use_cases/setting/load_global_settings_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockGlobalSettingRepository extends Mock
    implements GlobalSettingRepositoryInterface {}

late MockGlobalSettingRepository _repository;
late LoadGlobalSettingsUseCase _useCase;
late List<GlobalSetting<dynamic>> _settings;
void main() {
  _repository = MockGlobalSettingRepository();
  _useCase = LoadGlobalSettingsUseCase(repository: _repository);

  _settings = List.generate(
    5,
    (index) => GlobalSetting(
      code: 'testCode',
      module: 'testModule',
      value: 'testValue',
      type: GlobalSettingType.string,
    ),
  );

  setUpAll(
    () => {
      when(
        () => _repository.list(),
      ).thenAnswer((_) async => _settings),
    },
  );

  test('Should return correct list of settings', () async {
    final result = await _useCase();

    expect(result, _settings);

    verify(
      () => _repository.list(),
    ).called(1);
  });
}
