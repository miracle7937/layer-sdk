import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/_migration/data_layer/models.dart' as migration;
import 'package:layer_sdk/data_layer/network.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases/device_session/load_sessions_use_case.dart';
import 'package:layer_sdk/domain_layer/use_cases/device_session/session_terminate_use_case.dart';
import 'package:layer_sdk/presentation_layer/cubits/device_session/device_session_cubit.dart';
import 'package:layer_sdk/presentation_layer/cubits/device_session/device_session_state.dart';

import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockDeviceSessionRepository extends Mock
    implements DeviceSessionRepositoryInterface {}

final _repository = MockDeviceSessionRepository();
final _loadSessions = LoadSessionsUseCase(repository: _repository);
final _terminateSession =
    DeviceSessionTerminateUseCase(repository: _repository);
final deviceSession = DeviceSession();

final _limit = 2;

final _successSessionTypes = [SessionType.android, SessionType.iOS];
final _failureDeviceSessionType = [SessionType.other];

final _netException = NetException(message: 'Server timed out');
final _genericException = Exception();

final _mockedDeviceSessions = List.generate(
  4,
  (index) => DeviceSession(
      loginName: 'Session $index',
      deviceName: "device name",
      type: SessionType.android,
      customerId: "customer"),
);
final _mockedSessionsData = List.generate(
  2,
  (index) => SessionData(
      session: DeviceSession(
          loginName: 'Session $index',
          deviceName: "device name",
          type: SessionType.android,
          customerId: "customer")),
);

void main() {
  EquatableConfig.stringify = true;

  setUpAll(() {
    when(
      () => _repository.getDeviceSessions(
        deviceTypes: _successSessionTypes,
        status: SessionStatus.active,
        desc: any(named: 'desc'),
        sortby: any(named: 'sortby'),
      ),
    ).thenAnswer((_) async => _mockedDeviceSessions.take(_limit).toList());

    when(
      () => _repository.getDeviceSessions(
        deviceTypes: _successSessionTypes,
        status: SessionStatus.inactive,
        sortby: any(named: 'sortby'),
        desc: any(named: 'desc'),
      ),
    ).thenAnswer((_) async => _mockedDeviceSessions.take(_limit).toList());

    when(
      () => _repository.getDeviceSessions(
        deviceTypes: _failureDeviceSessionType,
        status: SessionStatus.active,
        sortby: any(named: 'sortby'),
        desc: any(named: 'desc'),
      ),
    ).thenThrow(_netException);

    when(
      () => _repository.getDeviceSessions(
        deviceTypes: _failureDeviceSessionType,
        status: SessionStatus.active,
        sortby: any(named: 'sortby'),
        desc: any(named: 'desc'),
      ),
    ).thenThrow(_genericException);
  });

  group(
    'DeviceSessionCubit for All',
    () => _testType(_loadSessions, _terminateSession),
  );
}

void _testType(LoadSessionsUseCase userCase,
    DeviceSessionTerminateUseCase terminateUseCase) {
  final defaultState = DeviceSessionState(
      customerId: 'customer', customerType: migration.CustomerType.joint);

  blocTest<DeviceSessionCubit, DeviceSessionState>(
    'starts on empty state',
    build: () => DeviceSessionCubit(
        customerId: 'customer',
        customerType: migration.CustomerType.joint,
        loadSessionsUseCase: userCase,
        terminateUseCase: terminateUseCase),
    verify: (c) => expect(
      c.state,
      defaultState,
    ),
  ); // starts on empty state

  blocTest<DeviceSessionCubit, DeviceSessionState>(
    'should load DeviceSessions',
    build: () => DeviceSessionCubit(
      customerId: 'customer',
      customerType: migration.CustomerType.joint,
      loadSessionsUseCase: userCase,
      terminateUseCase: terminateUseCase,
    ),
    act: (c) => c.load(),
    expect: () => [
      defaultState.copyWith(busy: true),
      defaultState.copyWith(sessions: _mockedSessionsData),
    ],
    verify: (c) {
      verify(
        () => _repository.getDeviceSessions(
          deviceTypes: _successSessionTypes,
          status: SessionStatus.active,
          sortby: any(named: 'sortby'),
          desc: any(named: 'desc'),
        ),
      ).called(1);
    },
  ); // should load DeviceSessions

  blocTest<DeviceSessionCubit, DeviceSessionState>(
    'should load using all parameters',
    build: () => DeviceSessionCubit(
      customerId: 'customer',
      customerType: migration.CustomerType.joint,
      loadSessionsUseCase: userCase,
      terminateUseCase: terminateUseCase,
    ),
    act: (c) => c.load(
      deviceTypes: _successSessionTypes,
      status: SessionStatus.active,
      sortby: "last_activity",
      desc: true,
    ),
    expect: () => [
      defaultState.copyWith(busy: true),
      defaultState.copyWith(sessions: _mockedSessionsData),
    ],
    verify: (c) {
      verify(
        () => _repository.getDeviceSessions(
          deviceTypes: _successSessionTypes,
          status: SessionStatus.active,
          sortby: any(named: 'sortby'),
          desc: any(named: 'desc'),
        ),
      ).called(1);
    },
  ); // should load using all parameters

  blocTest<DeviceSessionCubit, DeviceSessionState>(
    'should handle generic exceptions',
    build: () => DeviceSessionCubit(
      customerId: 'customer',
      customerType: migration.CustomerType.joint,
      loadSessionsUseCase: userCase,
      terminateUseCase: terminateUseCase,
    ),
    seed: () => defaultState.copyWith(
      sessions: _mockedSessionsData.take(_limit).toList(),
    ),
    act: (c) => c.load(
      deviceTypes: _failureDeviceSessionType,
    ),
    expect: () => [
      defaultState.copyWith(
        busy: true,
        sessions: _mockedSessionsData.take(_limit).toList(),
      ),
      defaultState.copyWith(
        sessions: _mockedSessionsData.take(_limit).toList(),
        errorStatus: DeviceSessionErrorStatus.generic,
        customerType: migration.CustomerType.joint,
      ),
    ],
    verify: (c) {
      verify(
        () => _repository.getDeviceSessions(
          deviceTypes: _failureDeviceSessionType,
          status: SessionStatus.active,
          sortby: null,
          desc: null,
        ),
      ).called(1);
    },
  ); // should handle generic exceptions
}
