import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/business_layer/business_layer.dart';
import 'package:layer_sdk/data_layer/data_layer.dart';
import 'package:layer_sdk/migration/data_layer/network.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockDeviceSessionRepository extends Mock
    implements DeviceSessionRepository {}

final _repository = MockDeviceSessionRepository();

final _customer1Id = '2819';
final _customer1Type = CustomerType.personal;
final _customer1Devices = <DeviceSession>[];
final _customer1BaseState = DeviceSessionState(
  customerId: _customer1Id,
  customerType: _customer1Type,
  sessions: <SessionData>[],
  busy: false,
);
late DeviceSession _customer1TerminateSession;

final _netErrorId = '1723';
final _genericErrorId = '7721';

void main() {
  EquatableConfig.stringify = true;

  for (var i = 0; i < 5; ++i) {
    _customer1Devices.add(
      DeviceSession(
        deviceId: 'id $i',
        status: SessionStatus.active,
        appVersion: 'version $i',
        created: DateTime.now(),
        type: i.isEven ? SessionType.android : SessionType.iOS,
      ),
    );
  }

  _customer1TerminateSession = _customer1Devices[2].copyWith(
    status: SessionStatus.wiped,
  );

  setUpAll(() {
    when(
      () => _repository.list(
        customerId: _customer1Id,
        forceRefresh: false,
      ),
    ).thenAnswer(
      (_) async => _customer1Devices,
    );

    when(
      () => _repository.list(
        customerId: _customer1Id,
        forceRefresh: true,
      ),
    ).thenAnswer(
      (_) async => _customer1Devices,
    );

    when(
      () => _repository.list(
        customerId: _netErrorId,
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenThrow(
      NetException(message: 'Failed.'),
    );

    when(
      () => _repository.list(
        customerId: _genericErrorId,
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenThrow(
      Exception('Failed generically.'),
    );

    when(
      () => _repository.terminateSession(
        customerType: _customer1Type,
        deviceId: _customer1TerminateSession.deviceId!,
      ),
    ).thenAnswer(
      (_) async => _customer1TerminateSession,
    );

    when(
      () => _repository.terminateSession(
        customerType: _customer1Type,
        deviceId: _customer1Devices[0].deviceId!,
      ),
    ).thenThrow(
      NetException(message: 'Failed.'),
    );
  });

  blocTest<DeviceSessionCubit, DeviceSessionState>(
    'starts on empty state',
    build: () => DeviceSessionCubit(
      repository: _repository,
      customerId: _customer1Id,
      customerType: _customer1Type,
    ),
    verify: (c) => expect(
      c.state,
      _customer1BaseState,
    ),
  ); // starts on empty state

  group('Device Session Load', _testLoad);
  group('Device Session Terminate', _testTerminate);
}

void _testLoad() {
  blocTest<DeviceSessionCubit, DeviceSessionState>(
    'should load sessions',
    build: () => DeviceSessionCubit(
      repository: _repository,
      customerId: _customer1Id,
      customerType: _customer1Type,
    ),
    act: (c) => c.load(),
    expect: () => [
      _customer1BaseState.copyWith(busy: true),
      _customer1BaseState.copyWith(
        sessions: _customer1Devices
            .map(
              (e) => SessionData(session: e),
            )
            .toList(),
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          customerId: _customer1Id,
          forceRefresh: false,
        ),
      ).called(1);
    },
  ); // should load sessions

  blocTest<DeviceSessionCubit, DeviceSessionState>(
    'should force load sessions',
    build: () => DeviceSessionCubit(
      repository: _repository,
      customerId: _customer1Id,
      customerType: _customer1Type,
    ),
    act: (c) => c.load(forceRefresh: true),
    expect: () => [
      _customer1BaseState.copyWith(busy: true),
      _customer1BaseState.copyWith(
        sessions: _customer1Devices
            .map(
              (e) => SessionData(session: e),
            )
            .toList(),
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          customerId: _customer1Id,
          forceRefresh: true,
        ),
      ).called(1);
    },
  ); // should force load sessions

  blocTest<DeviceSessionCubit, DeviceSessionState>(
    'should handle generic errors',
    build: () => DeviceSessionCubit(
      repository: _repository,
      customerId: _genericErrorId,
      customerType: _customer1Type,
    ),
    act: (c) => c.load(),
    expect: () => [
      _customer1BaseState.copyWith(
        customerId: _genericErrorId,
        busy: true,
      ),
      _customer1BaseState.copyWith(
        customerId: _genericErrorId,
        errorStatus: DeviceSessionErrorStatus.generic,
      ),
    ],
    errors: () => [
      isA<Exception>(),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          customerId: _genericErrorId,
          forceRefresh: false,
        ),
      ).called(1);
    },
  ); // should handle generic errors

  blocTest<DeviceSessionCubit, DeviceSessionState>(
    'should handle net exceptions',
    build: () => DeviceSessionCubit(
      repository: _repository,
      customerId: _netErrorId,
      customerType: _customer1Type,
    ),
    act: (c) => c.load(),
    expect: () => [
      _customer1BaseState.copyWith(
        customerId: _netErrorId,
        busy: true,
      ),
      _customer1BaseState.copyWith(
        customerId: _netErrorId,
        errorStatus: DeviceSessionErrorStatus.network,
      ),
    ],
    errors: () => [
      isA<NetException>(),
    ],
    verify: (c) {
      verify(
        () => _repository.list(
          customerId: _netErrorId,
          forceRefresh: false,
        ),
      ).called(1);
    },
  ); // should handle net exceptions
}

void _testTerminate() {
  blocTest<DeviceSessionCubit, DeviceSessionState>(
    'should terminate session',
    build: () => DeviceSessionCubit(
      repository: _repository,
      customerId: _customer1Id,
      customerType: _customer1Type,
    ),
    seed: () => _customer1BaseState.copyWith(
      sessions: _customer1Devices
          .map(
            (e) => SessionData(session: e),
          )
          .toList(),
      busy: false,
    ),
    act: (c) => c.terminateSession(
      deviceId: _customer1TerminateSession.deviceId!,
    ),
    expect: () => [
      _customer1BaseState.copyWith(
        sessions: _customer1Devices
            .map(
              (e) => SessionData(
                session: e,
                // Only this device should have busy set
                busy: e.deviceId == _customer1TerminateSession.deviceId,
              ),
            )
            .toList(),
        busy: false,
      ),
      _customer1BaseState.copyWith(
        sessions: _customer1Devices
            .map(
              (e) => SessionData(
                session: e.copyWith(
                  status: e.deviceId == _customer1TerminateSession.deviceId
                      ? SessionStatus.wiped
                      : null,
                ),
                busy: false,
              ),
            )
            .toList(),
        busy: false,
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.terminateSession(
          deviceId: _customer1TerminateSession.deviceId!,
          customerType: _customer1Type,
        ),
      ).called(1);
    },
  ); // should terminate session

  blocTest<DeviceSessionCubit, DeviceSessionState>(
    'should deal with exception',
    build: () => DeviceSessionCubit(
      repository: _repository,
      customerId: _customer1Id,
      customerType: _customer1Type,
    ),
    seed: () => _customer1BaseState.copyWith(
      sessions: _customer1Devices.map((e) => SessionData(session: e)).toList(),
      busy: false,
    ),
    act: (c) => c.terminateSession(
      deviceId: _customer1Devices[0].deviceId!,
    ),
    expect: () => [
      _customer1BaseState.copyWith(
        sessions: _customer1Devices
            .map(
              (e) => SessionData(
                session: e,
                busy: e.deviceId == _customer1Devices[0].deviceId,
              ),
            )
            .toList(),
        busy: false,
      ),
      _customer1BaseState.copyWith(
        sessions: _customer1Devices
            .map(
              (e) => SessionData(
                session: e,
                busy: false,
                errorStatus: e.deviceId == _customer1Devices[0].deviceId
                    ? DeviceSessionErrorStatus.network
                    : DeviceSessionErrorStatus.none,
              ),
            )
            .toList(),
        busy: false,
      ),
    ],
    errors: () => [
      isA<NetException>(),
    ],
    verify: (c) {
      verify(
        () => _repository.terminateSession(
          deviceId: _customer1Devices[0].deviceId!,
          customerType: _customer1Type,
        ),
      ).called(1);
    },
  ); // should deal with exception
}
