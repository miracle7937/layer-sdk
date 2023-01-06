import 'package:bloc_test/bloc_test.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:layer_sdk/presentation_layer/cubits.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockUseCase extends Mock implements RegisterCorporateAgentUseCase {}

class TestAgentCreationCubit extends AgentCreationCubit {
  final List<NewAgentStepStatus> Function(
    int currentStepIndex,
  ) _statusForNewCurrentIndex;

  TestAgentCreationCubit({
    required super.customer,
    required super.registerAgentUseCase,
    required super.stepsCubits,
    required List<NewAgentStepStatus> Function(
      int currentStepIndex,
    )
        statusForNewCurrentIndex,
  }) : _statusForNewCurrentIndex = statusForNewCurrentIndex;

  @override
  List<NewAgentStepStatus> statusForNewCurrentIndex(
    int currentStepIndex,
  ) =>
      _statusForNewCurrentIndex(currentStepIndex);
}

class TestStepCubit extends StepCubit<NewAgentStepState> {
  TestStepCubit(super.initialState);

  @override
  User get user => User(
        id: '',
        customerId: '',
        customerName: '',
        username: '',
        email: '',
        mobileNumber: '',
        firstName: '',
        lastName: '',
      );

  @override
  Future<bool> onContinue() {
    emit(state.copyWith(
      action: StepsStateAction.continueAction,
      completed: true,
    ));
    return Future.value(true);
  }
}

class MockNewAgentStepState extends Mock implements NewAgentStepState {}

class MockStepCubit extends Mock implements StepCubit<NewAgentStepState> {}

final _customerFullName = 'customerFullName';

class TestCustomer extends Customer {
  TestCustomer({required super.id});

  @override
  String get fullName => _customerFullName;
}

final _stepsCubits = UnmodifiableListView([
  TestStepCubit(
    NewAgentInformationStepState(),
  ),
  TestStepCubit(
    NewAgentInformationStepState(),
  ),
]);

final _mockStepCubit1 = MockStepCubit();
final _mockStepCubit2 = MockStepCubit();
final _mockStepCubit3 = MockStepCubit();

final _mockedStepsCubits = UnmodifiableListView([
  _mockStepCubit1,
  _mockStepCubit2,
  _mockStepCubit3,
]);

void main() {
  EquatableConfig.stringify = true;

  final useCase = MockUseCase();

  final customer = TestCustomer(id: 'id');

  final user = User(
    id: '',
    customerId: customer.id,
    customerName: '',
    username: '',
    email: '',
    mobileNumber: '',
    firstName: '',
    lastName: '',
  );

  setUpAll(() {
    when(
      () => useCase(
        user: user,
        isEditing: any(named: 'isEditing'),
      ),
    ).thenAnswer(
      (_) async => QueueRequest(),
    );
  });

  blocTest<AgentCreationCubit, AgentCreationState>(
    'Starts on empty state',
    build: () => AgentCreationCubit(
      customer: customer,
      registerAgentUseCase: useCase,
      stepsCubits: _stepsCubits,
    ),
    verify: (c) => expect(
      c.state,
      AgentCreationState(
        stepsStatuses: [
          NewAgentStepStatus.current,
          ...List.filled(
            _stepsCubits.length - 1,
            NewAgentStepStatus.upcoming,
          ),
        ],
      ),
    ),
  ); // starts on empty state

  blocTest<AgentCreationCubit, AgentCreationState>(
    'Trying to continue to next step '
    'when current one is not completed',
    setUp: () {
      when(
        _mockStepCubit1.onContinue,
      ).thenAnswer(
        (_) async => Future.value(false),
      );
    },
    build: () => AgentCreationCubit(
      customer: customer,
      registerAgentUseCase: useCase,
      stepsCubits: _mockedStepsCubits,
    ),
    act: (c) => c.onContinue(),
    expect: () => [
      AgentCreationState(
        busy: true,
        stepsStatuses: [
          NewAgentStepStatus.current,
          ...List.filled(
            _mockedStepsCubits.length - 1,
            NewAgentStepStatus.upcoming,
          ),
        ],
      ),
      AgentCreationState(
        busy: false,
        stepsStatuses: [
          NewAgentStepStatus.current,
          ...List.filled(
            _mockedStepsCubits.length - 1,
            NewAgentStepStatus.upcoming,
          ),
        ],
      ),
    ],
  );

  blocTest<AgentCreationCubit, AgentCreationState>(
    'Successful continue to next step',
    setUp: () {
      when(
        _mockStepCubit1.onContinue,
      ).thenAnswer(
        (_) async => Future.value(true),
      );
    },
    build: () => TestAgentCreationCubit(
      customer: customer,
      registerAgentUseCase: useCase,
      stepsCubits: _mockedStepsCubits,
      statusForNewCurrentIndex: (index) {
        return [
          NewAgentStepStatus.completed,
          NewAgentStepStatus.current,
          NewAgentStepStatus.upcoming,
        ];
      },
    ),
    act: (c) => c.onContinue(),
    expect: () => [
      AgentCreationState(
        busy: true,
        stepsStatuses: [
          NewAgentStepStatus.current,
          ...List.filled(
            _mockedStepsCubits.length - 1,
            NewAgentStepStatus.upcoming,
          ),
        ],
      ),
      AgentCreationState(
        busy: false,
        stepsStatuses: [
          NewAgentStepStatus.current,
          ...List.filled(
            _mockedStepsCubits.length - 1,
            NewAgentStepStatus.upcoming,
          ),
        ],
      ),
      AgentCreationState(
        busy: false,
        action: StepsStateAction.continueAction,
        currentStepIndex: 1,
        stepsStatuses: [
          NewAgentStepStatus.completed,
          NewAgentStepStatus.current,
          NewAgentStepStatus.upcoming,
        ],
      ),
    ],
  );

  final username = 'username';
  final role1 = 'Role1';
  final role2 = 'Role2';
  final account1 = Account(id: 'id1');
  final account2 = Account(id: 'id2');

  blocTest<AgentCreationCubit, AgentCreationState>(
    'Successful registration of new agent',
    setUp: () {
      when(
        () => useCase(
          user: user.copyWith(
            username: username,
            customerName: customer.fullName,
            roles: [role1, role2],
            visibleAccounts: [account1, account2],
          ),
          isEditing: any(named: 'isEditing'),
        ),
      ).thenAnswer(
        (_) async => QueueRequest(),
      );

      when(
        _mockStepCubit3.onContinue,
      ).thenAnswer(
        (_) async => Future.value(true),
      );
      when(
        () => _mockStepCubit1.user,
      ).thenReturn(
        user.copyWith(
          username: username,
        ),
      );
      when(
        () => _mockStepCubit2.user,
      ).thenReturn(
        user.copyWith(
          roles: [role1, role2],
        ),
      );
      when(
        () => _mockStepCubit3.user,
      ).thenReturn(
        user.copyWith(
          visibleAccounts: [account1, account2],
        ),
      );
    },
    build: () => AgentCreationCubit(
      customer: customer,
      registerAgentUseCase: useCase,
      stepsCubits: _mockedStepsCubits,
    ),
    seed: () => AgentCreationState(
      stepsStatuses: [
        NewAgentStepStatus.completed,
        NewAgentStepStatus.completed,
        NewAgentStepStatus.current,
      ],
      currentStepIndex: 2,
    ),
    act: (c) => c.onContinue(),
    expect: () => [
      AgentCreationState(
        busy: true,
        stepsStatuses: [
          NewAgentStepStatus.completed,
          NewAgentStepStatus.completed,
          NewAgentStepStatus.current,
        ],
        currentStepIndex: 2,
      ),
      AgentCreationState(
        busy: false,
        stepsStatuses: [
          NewAgentStepStatus.completed,
          NewAgentStepStatus.completed,
          NewAgentStepStatus.current,
        ],
        currentStepIndex: 2,
      ),
      AgentCreationState(
        busy: true,
        action: StepsStateAction.confirmCompletionAction,
        stepsStatuses: [
          NewAgentStepStatus.completed,
          NewAgentStepStatus.completed,
          NewAgentStepStatus.current,
        ],
        currentStepIndex: 2,
      ),
      AgentCreationState(
        busy: false,
        action: StepsStateAction.confirmCompletionAction,
        currentStepIndex: 2,
        stepsStatuses: [
          NewAgentStepStatus.completed,
          NewAgentStepStatus.completed,
          NewAgentStepStatus.current,
        ],
      ),
    ],
  );

  blocTest<AgentCreationCubit, AgentCreationState>(
    'Fail registration of new agent',
    setUp: () {
      when(
        () => useCase(
          user: user.copyWith(
            username: username,
            customerName: customer.fullName,
            roles: [role1, role2],
            visibleAccounts: [account1, account2],
          ),
          isEditing: any(named: 'isEditing'),
        ),
      ).thenAnswer(
        (_) async => throw Exception('Some error'),
      );

      when(
        _mockStepCubit3.onContinue,
      ).thenAnswer(
        (_) async => Future.value(true),
      );
      when(
        () => _mockStepCubit1.user,
      ).thenReturn(
        user.copyWith(
          username: username,
        ),
      );
      when(
        () => _mockStepCubit2.user,
      ).thenReturn(
        user.copyWith(
          roles: [role1, role2],
        ),
      );
      when(
        () => _mockStepCubit3.user,
      ).thenReturn(
        user.copyWith(
          visibleAccounts: [account1, account2],
        ),
      );
    },
    build: () => AgentCreationCubit(
      customer: customer,
      registerAgentUseCase: useCase,
      stepsCubits: _mockedStepsCubits,
    ),
    seed: () => AgentCreationState(
      stepsStatuses: [
        NewAgentStepStatus.completed,
        NewAgentStepStatus.completed,
        NewAgentStepStatus.current,
      ],
      currentStepIndex: 2,
    ),
    act: (c) => c.onContinue(),
    expect: () => [
      AgentCreationState(
        busy: true,
        stepsStatuses: [
          NewAgentStepStatus.completed,
          NewAgentStepStatus.completed,
          NewAgentStepStatus.current,
        ],
        currentStepIndex: 2,
      ),
      AgentCreationState(
        busy: false,
        stepsStatuses: [
          NewAgentStepStatus.completed,
          NewAgentStepStatus.completed,
          NewAgentStepStatus.current,
        ],
        currentStepIndex: 2,
      ),
      AgentCreationState(
        busy: true,
        action: StepsStateAction.confirmCompletionAction,
        stepsStatuses: [
          NewAgentStepStatus.completed,
          NewAgentStepStatus.completed,
          NewAgentStepStatus.current,
        ],
        currentStepIndex: 2,
      ),
      AgentCreationState(
        busy: false,
        action: StepsStateAction.confirmCompletionAction,
        currentStepIndex: 2,
        stepsStatuses: [
          NewAgentStepStatus.completed,
          NewAgentStepStatus.completed,
          NewAgentStepStatus.current,
        ],
        error: AgentCreationStateError.generic,
      ),
    ],
  );

  blocTest<AgentCreationCubit, AgentCreationState>(
    'Returning to previous step',
    build: () => TestAgentCreationCubit(
      customer: customer,
      registerAgentUseCase: useCase,
      stepsCubits: _mockedStepsCubits,
      statusForNewCurrentIndex: (index) {
        return [
          NewAgentStepStatus.current,
          NewAgentStepStatus.upcoming,
          NewAgentStepStatus.upcoming,
        ];
      },
    ),
    seed: () => AgentCreationState(
      stepsStatuses: [
        NewAgentStepStatus.completed,
        NewAgentStepStatus.current,
        NewAgentStepStatus.upcoming,
      ],
      currentStepIndex: 1,
    ),
    act: (c) => c.onBack(),
    expect: () => [
      AgentCreationState(
        action: StepsStateAction.backAction,
        stepsStatuses: [
          NewAgentStepStatus.current,
          NewAgentStepStatus.upcoming,
          NewAgentStepStatus.upcoming,
        ],
        currentStepIndex: 0,
      ),
    ],
  );

  final testStepCubit1 = TestStepCubit(NewAgentStepState(completed: true));
  final testStepCubit2 = TestStepCubit(NewAgentStepState(completed: true));
  final testStepCubit3 = TestStepCubit(NewAgentStepState(completed: false));

  blocTest<AgentCreationCubit, AgentCreationState>(
    'Changing step to another one by index, '
    'emits new steps statuses and current index',
    build: () => AgentCreationCubit(
      customer: customer,
      registerAgentUseCase: useCase,
      stepsCubits: UnmodifiableListView([
        testStepCubit1,
        testStepCubit2,
        testStepCubit3,
      ]),
    ),
    seed: () => AgentCreationState(
      stepsStatuses: [
        NewAgentStepStatus.completed,
        NewAgentStepStatus.completed,
        NewAgentStepStatus.current,
      ],
      currentStepIndex: 2,
    ),
    act: (c) => c.changeStep(index: 0),
    expect: () => [
      AgentCreationState(
        action: StepsStateAction.selectAction,
        stepsStatuses: [
          NewAgentStepStatus.current,
          NewAgentStepStatus.completed,
          NewAgentStepStatus.upcoming,
        ],
        currentStepIndex: 0,
      ),
    ],
  );

  final testStepCubit4 = TestStepCubit(NewAgentStepState(completed: true));
  final testStepCubit5 = TestStepCubit(NewAgentStepState(completed: false));
  final testStepCubit6 = TestStepCubit(NewAgentStepState(completed: false));

  blocTest<AgentCreationCubit, AgentCreationState>(
    'Trying to change step to upcoming, '
    'emits nothing, changing is not possible',
    build: () => AgentCreationCubit(
      customer: customer,
      registerAgentUseCase: useCase,
      stepsCubits: UnmodifiableListView([
        testStepCubit4,
        testStepCubit5,
        testStepCubit6,
      ]),
    ),
    seed: () => AgentCreationState(
      stepsStatuses: [
        NewAgentStepStatus.completed,
        NewAgentStepStatus.current,
        NewAgentStepStatus.upcoming,
      ],
      currentStepIndex: 1,
    ),
    act: (c) => c.changeStep(index: 2),
    expect: () => [],
  );
}
