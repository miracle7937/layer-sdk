import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/data_layer/network.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/models/setting/global_setting.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:layer_sdk/presentation_layer/cubits.dart';
import 'package:mocktail/mocktail.dart';

class MockGlobalSettingRepository extends Mock
    implements GlobalSettingRepositoryInterface {}

late MockGlobalSettingRepository _repository;
late LoadGlobalSettingsUseCase _useCase;
late List<GlobalSetting<dynamic>> _settings;
List<String> _codes = ['code2', 'code3'];
late List<String> _allCodes;
String _netExceptionCode = '1111';
String _genericExceptionCode = '2222';

void main() {
  _repository = MockGlobalSettingRepository();
  _useCase = LoadGlobalSettingsUseCase(repository: _repository);
  _settings = List.generate(
    4,
    (index) => GlobalSetting(
      code: 'code$index',
      module: 'module$index',
      type: GlobalSettingType.string,
      value: 'value$index',
    ),
  );

  _allCodes = _settings
      .map(
        (setting) => setting.code,
      )
      .toList(growable: false);

  setUpAll(
    () {
      when(
        () => _repository.list(),
      ).thenAnswer(
        (_) async => _settings,
      );

      when(
        () => _repository.list(
          codes: _codes,
        ),
      ).thenAnswer(
        (_) async => _settings
            .where(
              (setting) => _codes.contains(setting.code),
            )
            .toList(),
      );

      when(
        () => _repository.list(
          codes: _allCodes,
          forceRefresh: true,
        ),
      ).thenAnswer(
        (_) async => _settings,
      );

      when(
        () => _useCase(
          codes: [_netExceptionCode],
        ),
      ).thenThrow(
        NetException(message: 'Some network error'),
      );

      when(
        () => _useCase(
          codes: [_genericExceptionCode],
        ),
      ).thenThrow(
        Exception('Some generic error'),
      );
    },
  );

  blocTest<GlobalSettingCubit, GlobalSettingState>(
    'Start with an empty state',
    build: () => GlobalSettingCubit(
      getGlobalSettingUseCase: _useCase,
    ),
    verify: (c) => expect(
      c.state,
      GlobalSettingState(
        error: GlobalSettingError.none,
        busy: false,
      ),
    ),
  );

  blocTest<GlobalSettingCubit, GlobalSettingState>(
    'Should load all settings',
    build: () => GlobalSettingCubit(
      getGlobalSettingUseCase: _useCase,
    ),
    act: (c) => c.load(),
    expect: () => [
      GlobalSettingState(
        busy: true,
        error: GlobalSettingError.none,
      ),
      GlobalSettingState(
        busy: false,
        error: GlobalSettingError.none,
        settings: _settings,
      ),
    ],
    verify: (c) => verify(
      () => _repository.list(),
    ).called(1),
  );

  blocTest<GlobalSettingCubit, GlobalSettingState>(
    'Should load settings by codes',
    build: () => GlobalSettingCubit(
      getGlobalSettingUseCase: _useCase,
    ),
    act: (c) => c.load(
      codes: _codes,
    ),
    expect: () => [
      GlobalSettingState(
        busy: true,
        error: GlobalSettingError.none,
      ),
      GlobalSettingState(
        busy: false,
        error: GlobalSettingError.none,
        settings: [
          _settings[2],
          _settings[3],
        ],
      ),
    ],
    verify: (c) => verify(
      () => _repository.list(
        codes: _codes,
      ),
    ).called(1),
  );

  blocTest<GlobalSettingCubit, GlobalSettingState>(
    'Should not load current settings again',
    build: () => GlobalSettingCubit(
      getGlobalSettingUseCase: _useCase,
    ),
    seed: () => GlobalSettingState(
      settings: [
        _settings[0],
        _settings[1],
      ],
    ),
    act: (c) => c.load(
      codes: _allCodes,
    ),
    expect: () => [
      GlobalSettingState(
        busy: true,
        error: GlobalSettingError.none,
        settings: [
          _settings[0],
          _settings[1],
        ],
      ),
      GlobalSettingState(
        busy: false,
        error: GlobalSettingError.none,
        settings: _settings,
      ),
    ],
    verify: (c) => verify(
      () => _repository.list(
        codes: _codes,
      ),
    ).called(1),
  );

  blocTest<GlobalSettingCubit, GlobalSettingState>(
    'Should load current settings again when force refreshed',
    build: () => GlobalSettingCubit(
      getGlobalSettingUseCase: _useCase,
    ),
    seed: () => GlobalSettingState(
      settings: [
        _settings[0],
        _settings[1],
      ],
    ),
    act: (c) => c.load(
      codes: _allCodes,
      forceRefresh: true,
    ),
    expect: () => [
      GlobalSettingState(
        busy: true,
        error: GlobalSettingError.none,
        settings: [
          _settings[0],
          _settings[1],
        ],
      ),
      GlobalSettingState(
        busy: false,
        error: GlobalSettingError.none,
        settings: _settings,
      ),
    ],
    verify: (c) => verify(
      () => _repository.list(
        codes: _allCodes,
        forceRefresh: true,
      ),
    ).called(1),
  );

  blocTest<GlobalSettingCubit, GlobalSettingState>(
    'Should handle network exceptions',
    build: () => GlobalSettingCubit(
      getGlobalSettingUseCase: _useCase,
    ),
    act: (c) => c.load(codes: [_netExceptionCode]),
    expect: () => [
      GlobalSettingState(
        busy: true,
        error: GlobalSettingError.none,
      ),
      GlobalSettingState(
        busy: false,
        error: GlobalSettingError.network,
        settings: [],
        errorMessage: 'Some network error',
      ),
    ],
    errors: () => [
      isA<NetException>(),
    ],
    verify: (c) => verify(
      () => _repository.list(
        codes: [_netExceptionCode],
      ),
    ).called(1),
  );

  blocTest<GlobalSettingCubit, GlobalSettingState>(
    'Should handle generic exceptions',
    build: () => GlobalSettingCubit(
      getGlobalSettingUseCase: _useCase,
    ),
    act: (c) => c.load(codes: [_genericExceptionCode]),
    expect: () => [
      GlobalSettingState(
        busy: true,
        error: GlobalSettingError.none,
      ),
      GlobalSettingState(
        busy: false,
        error: GlobalSettingError.generic,
        settings: [],
      ),
    ],
    errors: () => [
      isA<Exception>(),
    ],
    verify: (c) => verify(
      () => _repository.list(
        codes: [_genericExceptionCode],
      ),
    ).called(1),
  );
}
