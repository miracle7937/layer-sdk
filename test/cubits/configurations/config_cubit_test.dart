import 'package:bloc_test/bloc_test.dart';
import 'package:layer_sdk/data_layer/network.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:layer_sdk/presentation_layer/cubits.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockLoadConfigUseCase extends Mock implements LoadConfigUseCase {}

late MockLoadConfigUseCase _loadConfigUseCase;
late ConfigCubit _cubit;

final _backendConfig = Config(
  showCustomersTab: true,
);

void main() {
  setUp(() {
    _loadConfigUseCase = MockLoadConfigUseCase();
    _cubit = ConfigCubit(loadConfigUseCase: _loadConfigUseCase);

    when(
      () => _loadConfigUseCase(),
    ).thenAnswer(
      (_) async => _backendConfig,
    );

    when(
      () => _loadConfigUseCase(forceRefresh: false),
    ).thenThrow(
      NetException(message: 'Failed.'),
    );
  });

  blocTest<ConfigCubit, ConfigState>(
    'Starts on empty state',
    build: () => _cubit,
    verify: (c) => expect(
      c.state,
      ConfigState(),
    ),
  );

  blocTest<ConfigCubit, ConfigState>(
    'Load backend configurations',
    build: () => _cubit,
    act: (c) => c.load(),
    expect: () => [
      ConfigState(busy: true),
      ConfigState(config: _backendConfig),
    ],
    verify: (c) {
      verify(() => _loadConfigUseCase()).called(1);
    },
  );

  blocTest<ConfigCubit, ConfigState>(
    'Should deal with exception',
    build: () => _cubit,
    act: (c) => c.load(forceRefresh: false),
    expect: () => [
      ConfigState(busy: true),
      ConfigState(error: ConfigStateErrors.generic),
    ],
    verify: (c) {
      verify(() => _loadConfigUseCase(forceRefresh: false)).called(1);
    },
    errors: () => [isA<NetException>()],
  );
}
