import 'package:bloc_test/bloc_test.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:layer_sdk/presentation_layer/cubits.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockRolesCubit extends Mock implements RolesCubit {}

class MockLoadCustomerRolesUseCase extends Mock
    implements LoadCustomerRolesUseCase {}

void main() {
  late MockRolesCubit mockRolesCubit;

  final roles = [
    Role(roleId: 'roleId1'),
    Role(roleId: 'roleId2'),
    Role(roleId: 'roleId3'),
  ];

  setUpAll(() {
    mockRolesCubit = MockRolesCubit();
    when(
      () => mockRolesCubit.state,
    ).thenReturn(RolesState());

    when(
      () => mockRolesCubit.stream,
    ).thenAnswer(
      (_) async* {
        yield RolesState(
          roles: roles,
        );
      },
    );
  });

  blocTest<NewAgentFeatureStepCubit, NewAgentFeatureStepState>(
    'Starts with loaded roles',
    setUp: () => when(
      () => mockRolesCubit.stream,
    ).thenAnswer(
      (_) async* {
        yield RolesState(
          roles: roles,
          busy: false,
        );
      },
    ),
    build: NewAgentFeatureStepCubit.new,
    verify: (c) => expect(
      c.state,
      NewAgentFeatureStepState(),
    ),
  );

  blocTest<NewAgentFeatureStepCubit, NewAgentFeatureStepState>(
    'Selects new role',
    setUp: () => when(
      () => mockRolesCubit.stream,
    ).thenAnswer(
      (_) async* {},
    ),
    build: NewAgentFeatureStepCubit.new,
    seed: () {
      return NewAgentFeatureStepState(
        selectedRoles: roles.take(2),
        action: StepsStateAction.editAction,
      );
    },
    act: (c) => c.onRoleTap(roles.last),
    expect: () => [
      NewAgentFeatureStepState(
        selectedRoles: roles,
        action: StepsStateAction.editAction,
      ),
    ],
  );

  blocTest<NewAgentFeatureStepCubit, NewAgentFeatureStepState>(
    'onContinue emits true for completed',
    setUp: () => when(
      () => mockRolesCubit.stream,
    ).thenAnswer(
      (_) async* {},
    ),
    build: NewAgentFeatureStepCubit.new,
    seed: () {
      return NewAgentFeatureStepState(
        selectedRoles: roles.take(2),
        action: StepsStateAction.editAction,
      );
    },
    act: (c) => c.onContinue(),
    expect: () => [
      NewAgentFeatureStepState(
        selectedRoles: roles.take(2),
        action: StepsStateAction.continueAction,
        completed: true,
      ),
    ],
  );
}
