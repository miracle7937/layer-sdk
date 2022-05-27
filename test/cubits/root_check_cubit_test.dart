import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/data_layer/data_layer.dart';
import 'package:layer_sdk/flutter_layer/flutter_layer.dart';
import 'package:layer_sdk/flutter_layer/src/cubits/root_check/check_super_wrapper.dart';
import 'package:mocktail/mocktail.dart';

class MockGlobalSettingRepository extends Mock
    implements GlobalSettingRepository {}

class MockCheckSuperWrapper extends Mock implements CheckSuperWrapper {}

void main() {
  late MockGlobalSettingRepository repository;
  late MockCheckSuperWrapper checkSuperWrapper;

  setUp(() {
    repository = MockGlobalSettingRepository();
    checkSuperWrapper = MockCheckSuperWrapper();
  });

  blocTest<RootCheckCubit, RootCheckState>(
    'Should start with an empty state',
    build: () => RootCheckCubit(
      globalSettingRepository: repository,
      checkSuperWrapper: checkSuperWrapper,
    ),
    verify: (c) => expect(
      c.state,
      RootCheckState(),
    ),
  );

  group('Exception handling', () {
    setUp(() {
      when(checkSuperWrapper.isDeviceRooted).thenThrow(Exception(''));
    });

    blocTest<RootCheckCubit, RootCheckState>(
      'Should return failed status on exception',
      build: () => RootCheckCubit(
        globalSettingRepository: repository,
        checkSuperWrapper: checkSuperWrapper,
      ),
      act: (c) => c.checkStatus(),
      expect: () => [
        RootCheckState(busy: true),
        RootCheckState(status: RootCheckStatus.failed),
      ],
    );
  });

  group('Device rooted handling', () {
    final trueSetting = GlobalSetting<bool>(
      code: 'unsecure_device_support',
      module: 'module',
      type: GlobalSettingType.bool,
      value: true,
    );
    final falseSetting = GlobalSetting<bool>(
      code: 'unsecure_device_support',
      module: 'module',
      type: GlobalSettingType.bool,
      value: false,
    );

    setUp(() {
      when(() => checkSuperWrapper.isDeviceRooted())
          .thenAnswer((_) async => true);
    });

    blocTest<RootCheckCubit, RootCheckState>(
      'Should check unsecure device setting and return rootedAllowed.',
      build: () {
        when(() => repository.list(codes: ['unsecure_device_support']))
            .thenAnswer(
          (_) async => [trueSetting],
        );
        return RootCheckCubit(
          globalSettingRepository: repository,
          checkSuperWrapper: checkSuperWrapper,
        );
      },
      act: (c) => c.checkStatus(),
      expect: () => [
        RootCheckState(busy: true),
        RootCheckState(status: RootCheckStatus.rootedAllowed),
      ],
      verify: (c) {
        verify(() => checkSuperWrapper.isDeviceRooted()).called(1);
        verify(() => repository.list(codes: ['unsecure_device_support']))
            .called(1);
      },
    );

    blocTest<RootCheckCubit, RootCheckState>(
      'Should check unsecure device setting and return rootedDisallowed.',
      build: () {
        when(() => repository.list(codes: ['unsecure_device_support']))
            .thenAnswer(
          (_) async => [falseSetting],
        );
        return RootCheckCubit(
          globalSettingRepository: repository,
          checkSuperWrapper: checkSuperWrapper,
        );
      },
      act: (c) => c.checkStatus(),
      expect: () => [
        RootCheckState(busy: true),
        RootCheckState(status: RootCheckStatus.rootedDisallowed),
      ],
      verify: (c) {
        verify(() => checkSuperWrapper.isDeviceRooted()).called(1);
        verify(() => repository.list(codes: ['unsecure_device_support']))
            .called(1);
      },
    );
  });

  group('Device unrooted handling', () {
    setUp(() {
      when(() => checkSuperWrapper.isDeviceRooted())
          .thenAnswer((_) async => false);
    });

    blocTest<RootCheckCubit, RootCheckState>(
      'Should return nonRooted.',
      build: () {
        return RootCheckCubit(
          globalSettingRepository: repository,
          checkSuperWrapper: checkSuperWrapper,
        );
      },
      act: (c) => c.checkStatus(),
      expect: () => [
        RootCheckState(busy: true),
        RootCheckState(status: RootCheckStatus.nonRooted),
      ],
      verify: (c) {
        verify(() => checkSuperWrapper.isDeviceRooted()).called(1);
        verifyNever(() => repository.list(codes: ['unsecure_device_support']));
      },
    );
  });
}
