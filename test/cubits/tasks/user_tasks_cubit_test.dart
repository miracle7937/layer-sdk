import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/data_layer/network.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:layer_sdk/presentation_layer/cubits.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockListUserTasksUseCase extends Mock implements ListUserTasksUseCase {}

class MockFinishTaskUseCase extends Mock implements FinishTaskUseCase {}

final _repositoryList = <DPATask>[];
final _customerList = <DPATask>[];

final _fixedCustomer = Customer(
  id: 'Fixed',
  firstName: 'Fixed costumer',
  status: CustomerStatus.active,
  type: CustomerType.personal,
);

late MockListUserTasksUseCase _listUserTasksUseCase;
late MockFinishTaskUseCase _finishTaskUseCase;

UserTasksCubit create({String? customerId}) => UserTasksCubit(
      userTasksUseCase: _listUserTasksUseCase,
      finishTaskUseCase: _finishTaskUseCase,
      customerId: customerId,
    );

void main() {
  EquatableConfig.stringify = true;

  for (var i = 0; i < 23; ++i) {
    _repositoryList.add(
      DPATask(
        id: '$i',
        name: 'Task $i',
        status: i.isEven ? DPAStatus.active : DPAStatus.completed,
        customer: Customer(
          id: 'customer  $i',
          firstName: 'Name $i',
          status: CustomerStatus.active,
          type: CustomerType.personal,
        ),
        created: DateTime.now(),
        priority: i,
        previousTasksIds: [],
      ),
    );
  }

  for (var i = 0; i < 7; ++i) {
    _customerList.add(
      DPATask(
        id: 'Customer task $i',
        name: 'Task $i',
        status: i.isOdd ? DPAStatus.active : DPAStatus.completed,
        customer: _fixedCustomer,
        created: DateTime.now(),
        priority: i,
        previousTasksIds: [],
      ),
    );
  }

  setUpAll(() {
    registerFallbackValue(
      DPATask(
        id: 'fallback_id',
        name: 'fallback_name',
        status: DPAStatus.active,
        previousTasksIds: [],
      ),
    );
    _listUserTasksUseCase = MockListUserTasksUseCase();
    _finishTaskUseCase = MockFinishTaskUseCase();

    when(
      () => _listUserTasksUseCase(
        customerId: _fixedCustomer.id,
        fetchCustomersData: false,
      ),
    ).thenAnswer(
      (_) async => _customerList.toList(),
    );

    when(
      () => _listUserTasksUseCase(
        forceRefresh: any(named: 'forceRefresh'),
      ),
    ).thenAnswer(
      (_) async => _repositoryList.toList(),
    );
  });

  blocTest<UserTasksCubit, UserTasksState>(
    'starts on empty state',
    build: create,
    verify: (c) => expect(
      c.state,
      UserTasksState(),
    ),
  ); // starts on empty state

  blocTest<UserTasksCubit, UserTasksState>(
    'should load tasks without customer id',
    build: create,
    act: (c) => c.load(),
    expect: () => [
      UserTasksState(busy: true),
      UserTasksState(
        tasks: _repositoryList,
      ),
    ],
    verify: (c) {
      verify(
        () => _listUserTasksUseCase(
          fetchCustomersData: true,
          forceRefresh: false,
        ),
      ).called(1);
    },
  ); // should load tasks without customer id

  blocTest<UserTasksCubit, UserTasksState>(
    'should load tasks with customer id',
    build: () => create(
      customerId: _fixedCustomer.id,
    ),
    act: (c) => c.load(),
    expect: () => [
      UserTasksState(
        customerId: _fixedCustomer.id,
        busy: true,
      ),
      UserTasksState(
        customerId: _fixedCustomer.id,
        tasks: _customerList,
      ),
    ],
    verify: (c) {
      verify(
        () => _listUserTasksUseCase(
          customerId: _fixedCustomer.id,
          fetchCustomersData: false,
          forceRefresh: false,
        ),
      ).called(1);
    },
  ); // should load tasks with customer id

  blocTest<UserTasksCubit, UserTasksState>(
    'should force load tasks without customer id',
    build: create,
    act: (c) => c.load(forceRefresh: true),
    expect: () => [
      UserTasksState(busy: true),
      UserTasksState(
        tasks: _repositoryList,
      ),
    ],
    verify: (c) {
      verify(
        () => _listUserTasksUseCase(
          fetchCustomersData: true,
          forceRefresh: true,
        ),
      ).called(1);
    },
  ); // should force load tasks without customer id

  group('Error handling', () {
    setUp(() {
      when(
        () => _listUserTasksUseCase(),
      ).thenThrow(
        NetException(message: 'Error'),
      );
    });

    blocTest<UserTasksCubit, UserTasksState>(
      'should deal with simple exceptions',
      build: create,
      act: (c) => c.load(),
      expect: () => [
        UserTasksState(busy: true),
        UserTasksState(
          errorStatus: UserTasksErrorStatus.network,
        ),
      ],
      verify: (c) {
        verify(() => _listUserTasksUseCase()).called(1);
      },
    ); // should deal with simple exceptions
  });

  group('Finalize Task', _finalizeTests);
}

void _finalizeTests() {
  DPATask _updateDecision(DPATask task, String decision) => task.copyWith(
        variables: task.variables.map(
          (e) => e.id.toLowerCase() == 'decision'
              ? e.copyWith(value: decision)
              : e,
        ),
      );

  final defaultDecision = 'T';
  final updatedDecision = 'U';
  final finalizeTasks = <DPATask>[];

  for (var i = 0; i < 10; ++i) {
    finalizeTasks.add(
      DPATask(
        id: 'decide$i',
        name: 'Task $i',
        variables: <DPAVariable>[
          DPAVariable(
            id: 'decision',
            value: defaultDecision,
            constraints: DPAConstraint(),
            type: DPAVariableType.text,
            submitType: 'string',
            property: DPAVariableProperty(),
          ),
        ],
        previousTasksIds: [],
        status: DPAStatus.active,
      ),
    );
  }

  final successTask = finalizeTasks[3];
  final failedTask = finalizeTasks[7];
  final errorTask = finalizeTasks[2];

  setUpAll(() {
    when(
      () => _finishTaskUseCase(task: any(named: 'task')),
    ).thenAnswer(
      (_) async => true,
    );

    when(
      () => _finishTaskUseCase(
        task: _updateDecision(failedTask, updatedDecision),
      ),
    ).thenAnswer(
      (_) async => false,
    );

    when(
      () => _finishTaskUseCase(
        task: _updateDecision(errorTask, updatedDecision),
      ),
    ).thenThrow(
      NetException(message: 'error'),
    );
  });

  blocTest<UserTasksCubit, UserTasksState>(
    'should finalize task',
    build: create,
    seed: () => UserTasksState(
      tasks: finalizeTasks,
    ),
    act: (c) => c.finalize(
      task: successTask,
      decision: updatedDecision,
    ),
    expect: () => [
      UserTasksState(busy: true, tasks: finalizeTasks),
      UserTasksState(
        action: UserTasksAction.finalizedTask,
        tasks: finalizeTasks.where((e) => e.id != successTask.id),
      ),
    ],
    verify: (c) {
      verify(
        () => _finishTaskUseCase(
          task: _updateDecision(successTask, updatedDecision),
        ),
      ).called(1);
    },
  ); // should finalize task

  blocTest<UserTasksCubit, UserTasksState>(
    'should emit error when failed to finalize',
    build: create,
    seed: () => UserTasksState(
      tasks: finalizeTasks,
    ),
    act: (c) => c.finalize(
      task: failedTask,
      decision: updatedDecision,
    ),
    expect: () => [
      UserTasksState(busy: true, tasks: finalizeTasks),
      UserTasksState(
        errorStatus: UserTasksErrorStatus.network,
        tasks: finalizeTasks,
      ),
    ],
    verify: (c) {
      verify(
        () => _finishTaskUseCase(
          task: _updateDecision(failedTask, updatedDecision),
        ),
      ).called(1);
    },
  ); // should emit error when failed to finalize

  blocTest<UserTasksCubit, UserTasksState>(
    'should deal with simple exceptions when finalizing',
    build: create,
    seed: () => UserTasksState(
      tasks: finalizeTasks,
    ),
    act: (c) => c.finalize(
      task: errorTask,
      decision: updatedDecision,
    ),
    expect: () => [
      UserTasksState(busy: true, tasks: finalizeTasks),
      UserTasksState(
        errorStatus: UserTasksErrorStatus.network,
        tasks: finalizeTasks,
      ),
    ],
    verify: (c) {
      verify(
        () => _finishTaskUseCase(
          task: _updateDecision(errorTask, updatedDecision),
        ),
      ).called(1);
    },
  ); // should deal with simple exceptions when finalizing
}
