import 'package:bloc_test/bloc_test.dart';
import 'package:layer_sdk/business_layer/business_layer.dart';
import 'package:layer_sdk/data_layer/data_layer.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockConfigRepository extends Mock implements ConfigRepository {}

late MockConfigRepository _configRepository;

Config _backendConfig = Config(
  showCustomersTab: true,
);

void main() {
  setUpAll(() {
    _configRepository = MockConfigRepository();

    when(
      () => _configRepository.load(),
    ).thenAnswer(
      (_) async => _backendConfig,
    );
  });

  blocTest<ConfigCubit, ConfigState>(
    'starts on empty state',
    build: () => ConfigCubit(repository: _configRepository),
    verify: (c) => expect(
      c.state,
      ConfigState(),
    ),
  );

  blocTest<ConfigCubit, ConfigState>(
    'load backend configurations',
    build: () => ConfigCubit(repository: _configRepository),
    act: (c) => c.load(),
    expect: () => [
      ConfigState(busy: true),
      ConfigState(config: _backendConfig),
    ],
    verify: (c) {
      verify(() => _configRepository.load()).called(1);
    },
  );

  group('Error handling', _dealWithErrors);
}

void _dealWithErrors() {
  setUpAll(() {
    when(
      () => _configRepository.load(),
    ).thenThrow(
      NetException(message: 'Failed.'),
    );
  });

  blocTest<ConfigCubit, ConfigState>(
    'should deal with exception',
    build: () => ConfigCubit(repository: _configRepository),
    act: (c) => c.load(),
    expect: () => [
      ConfigState(busy: true),
      ConfigState(error: ConfigStateErrors.generic),
    ],
    verify: (c) {
      verify(() => _configRepository.load()).called(1);
    },
    errors: () => [isA<NetException>()],
  );
}
