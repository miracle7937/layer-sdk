import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/_migration/business_layer/business_layer.dart';
import 'package:layer_sdk/_migration/data_layer/data_layer.dart';
import 'package:layer_sdk/data_layer/network.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockRolesRepository extends Mock implements RolesRepository {}

late MockRolesRepository _repo;
late List<Role> _mockedRoles;

void main() {
  EquatableConfig.stringify = true;

  _mockedRoles = List.generate(
    20,
    (index) => Role(
      numberOfUsers: index,
      priority: index,
      roleId: index.toString(),
    ),
  );

  setUpAll(() {
    _repo = MockRolesRepository();
  });

  group('RolesCubit general tests', _generalTests);
  group('RolesCubit failure tests', _failureTests);
}

void _generalTests() {
  setUp(() {
    when(
      () => _repo.listCustomerRoles(
        forceRefresh: true,
      ),
    ).thenAnswer((_) async => _mockedRoles);
  });

  blocTest<RolesCubit, RolesState>(
    'Starts with empty state',
    build: () => RolesCubit(repository: _repo),
    verify: (c) => expect(
      c.state,
      RolesState(),
    ),
  );

  blocTest<RolesCubit, RolesState>(
    'Loads roles successfully',
    build: () => RolesCubit(repository: _repo),
    act: (c) => c.listCustomerRoles(
      forceRefresh: true,
    ),
    expect: () => [
      RolesState(
        busy: true,
      ),
      RolesState(
        busy: false,
        roles: _mockedRoles,
      ),
    ],
    verify: (c) => verify(
      () => _repo.listCustomerRoles(forceRefresh: true),
    ).called(1),
  );
}

void _failureTests() {
  setUp(() {
    when(
      () => _repo.listCustomerRoles(
        forceRefresh: true,
      ),
    ).thenAnswer((_) async => throw Exception('Some error'));

    when(
      () => _repo.listCustomerRoles(
        forceRefresh: false,
      ),
    ).thenAnswer((_) async => throw NetException(message: 'Some error'));
  });

  blocTest<RolesCubit, RolesState>(
    'Handles general exceptions gracefully',
    build: () => RolesCubit(repository: _repo),
    act: (c) => c.listCustomerRoles(
      forceRefresh: true,
    ),
    expect: () => [
      RolesState(
        busy: true,
      ),
      RolesState(
        busy: false,
        error: RolesStateError.generic,
      ),
    ],
    errors: () => [
      isA<Exception>(),
    ],
    verify: (c) => verify(
      () => _repo.listCustomerRoles(forceRefresh: true),
    ).called(1),
  );

  blocTest<RolesCubit, RolesState>(
    'Handles network exceptions gracefully',
    build: () => RolesCubit(repository: _repo),
    act: (c) => c.listCustomerRoles(
      forceRefresh: false,
    ),
    expect: () => [
      RolesState(
        busy: true,
      ),
      RolesState(
        busy: false,
        error: RolesStateError.network,
      ),
    ],
    errors: () => [
      isA<NetException>(),
    ],
    verify: (c) => verify(
      () => _repo.listCustomerRoles(forceRefresh: false),
    ).called(1),
  );
}
