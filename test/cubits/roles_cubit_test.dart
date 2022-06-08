import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/data_layer/network.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:layer_sdk/presentation_layer/cubits.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockLoadCustomRolesUseCase extends Mock
    implements LoadCustomerRolesUseCase {}

late MockLoadCustomRolesUseCase _mockloadCustomRolesUseCase;
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
    _mockloadCustomRolesUseCase = MockLoadCustomRolesUseCase();
  });

  group('RolesCubit general tests', _generalTests);
  group('RolesCubit failure tests', _failureTests);
}

void _generalTests() {
  setUp(() {
    when(
      () => _mockloadCustomRolesUseCase(
        forceRefresh: true,
      ),
    ).thenAnswer((_) async => _mockedRoles);
  });

  blocTest<RolesCubit, RolesState>(
    'Starts with empty state',
    build: () => RolesCubit(
      loadCustomerRolesUseCase: _mockloadCustomRolesUseCase,
    ),
    verify: (c) => expect(
      c.state,
      RolesState(),
    ),
  );

  blocTest<RolesCubit, RolesState>(
    'Loads roles successfully',
    build: () => RolesCubit(
      loadCustomerRolesUseCase: _mockloadCustomRolesUseCase,
    ),
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
      () => _mockloadCustomRolesUseCase(forceRefresh: true),
    ).called(1),
  );
}

void _failureTests() {
  setUp(() {
    when(
      () => _mockloadCustomRolesUseCase(
        forceRefresh: true,
      ),
    ).thenAnswer((_) async => throw Exception('Some error'));

    when(
      () => _mockloadCustomRolesUseCase(
        forceRefresh: false,
      ),
    ).thenAnswer((_) async => throw NetException(message: 'Some error'));
  });

  blocTest<RolesCubit, RolesState>(
    'Handles general exceptions gracefully',
    build: () => RolesCubit(
      loadCustomerRolesUseCase: _mockloadCustomRolesUseCase,
    ),
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
      () => _mockloadCustomRolesUseCase(forceRefresh: true),
    ).called(1),
  );

  blocTest<RolesCubit, RolesState>(
    'Handles network exceptions gracefully',
    build: () => RolesCubit(
      loadCustomerRolesUseCase: _mockloadCustomRolesUseCase,
    ),
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
      () => _mockloadCustomRolesUseCase(forceRefresh: false),
    ).called(1),
  );
}
