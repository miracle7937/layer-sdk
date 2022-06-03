import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/_migration/flutter_layer/flutter_layer.dart';
import 'package:mocktail/mocktail.dart';

class MockDevicePermissionsWrapper extends Mock
    implements DevicePermissionsWrapper {}

late MockDevicePermissionsWrapper _permissionsWrapperMock;
final _grantedPermission = Permission.camera;
final _unknownPermission = Permission.calendar;
final _deniedPermission = Permission.contacts;
bool _openSettingsCalled = false;

void main() {
  EquatableConfig.stringify = true;
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    _permissionsWrapperMock = MockDevicePermissionsWrapper();
    _openSettingsCalled = false;

    when(
      () => _permissionsWrapperMock.status(_grantedPermission),
    ).thenAnswer((_) async => PermissionStatus.granted);
    when(
      () => _permissionsWrapperMock.status(_unknownPermission),
    ).thenAnswer((_) async => PermissionStatus.denied);
    when(
      () => _permissionsWrapperMock.request(_unknownPermission),
    ).thenAnswer((_) async => PermissionStatus.granted);
    when(
      () => _permissionsWrapperMock.status(_deniedPermission),
    ).thenAnswer((_) async => PermissionStatus.permanentlyDenied);
  });

  Future<void> _openSettingsStub() async {
    _openSettingsCalled = true;
  }

  blocTest<DevicePermissionsCubit, DevicePermissionsState>(
    'Should start on an empty state',
    build: () => DevicePermissionsCubit(
      wrapper: _permissionsWrapperMock,
    ),
    verify: (c) {
      expect(c.state, DevicePermissionsState());
    },
  );

  blocTest<DevicePermissionsCubit, DevicePermissionsState>(
    'Should simply emit granted permission',
    build: () => DevicePermissionsCubit(
      wrapper: _permissionsWrapperMock,
    ),
    act: (c) => c.requestPermission(
      openSettings: _openSettingsStub,
      permission: _grantedPermission,
    ),
    expect: () => [
      DevicePermissionsState(
        permissionStatus: {
          _grantedPermission: PermissionStatus.granted,
        },
      )
    ],
    verify: (c) {
      verify(
        () => _permissionsWrapperMock.status(_grantedPermission),
      ).called(1);
      verifyNever(() => _permissionsWrapperMock.request(_grantedPermission));
    },
  );

  blocTest<DevicePermissionsCubit, DevicePermissionsState>(
    'Should ask for permission and emit result',
    build: () => DevicePermissionsCubit(
      wrapper: _permissionsWrapperMock,
    ),
    act: (c) => c.requestPermission(
      openSettings: _openSettingsStub,
      permission: _unknownPermission,
    ),
    expect: () => [
      DevicePermissionsState(
        permissionStatus: {
          _unknownPermission: PermissionStatus.granted,
        },
      )
    ],
    verify: (c) {
      verify(() => _permissionsWrapperMock.status(_unknownPermission))
          .called(1);
      verify(() => _permissionsWrapperMock.request(_unknownPermission))
          .called(1);
      expect(_openSettingsCalled, false);
    },
  );

  blocTest<DevicePermissionsCubit, DevicePermissionsState>(
    'Should open settings and emit result',
    build: () => DevicePermissionsCubit(
      wrapper: _permissionsWrapperMock,
    ),
    act: (c) => c.requestPermission(
      openSettings: _openSettingsStub,
      permission: _deniedPermission,
    ),
    expect: () => [
      DevicePermissionsState(
        permissionStatus: {
          _deniedPermission: PermissionStatus.permanentlyDenied,
        },
      )
    ],
    verify: (c) {
      verify(() => _permissionsWrapperMock.status(_deniedPermission)).called(2);
      expect(_openSettingsCalled, true);
    },
  );

  blocTest<DevicePermissionsCubit, DevicePermissionsState>(
    'Should emit the permission status for the passed permission',
    build: () => DevicePermissionsCubit(
      wrapper: _permissionsWrapperMock,
    ),
    act: (c) => c.getPermissionStatus(
      _grantedPermission,
    ),
    expect: () => [
      DevicePermissionsState(
        permissionStatus: {
          _grantedPermission: PermissionStatus.granted,
        },
      )
    ],
    verify: (c) {
      verify(() => _permissionsWrapperMock.status(_grantedPermission))
          .called(1);
    },
  );
}
