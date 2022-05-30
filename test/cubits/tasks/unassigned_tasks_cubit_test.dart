import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/business_layer/business_layer.dart';
import 'package:layer_sdk/data_layer/data_layer.dart';
import 'package:layer_sdk/migration/data_layer/network.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockDPARepository extends Mock implements DPARepository {}

final _repositoryList = <DPATask>[];
final _customerList = <DPATask>[];

late MockDPARepository _repository;

final _fixedCustomer = Customer(
  id: 'Fixed',
  firstName: 'Fixed costumer',
  status: CustomerStatus.active,
  type: CustomerType.personal,
);

void main() {
  EquatableConfig.stringify = true;

  for (var i = 0; i < 5; ++i) {
    _repositoryList.add(
      DPATask(
        id: '$i',
        name: 'Task $i',
        status: DPAStatus.active,
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
    _repository = MockDPARepository();

    when(
      () => _repository.listUnassignedTasks(),
    ).thenAnswer(
      (_) async => _repositoryList.toList(),
    );

    when(
      () => _repository.listUnassignedTasks(
        customerId: _fixedCustomer.id,
      ),
    ).thenAnswer(
      (_) async => _customerList.toList(),
    );

    when(() => _repository.claimTask(
          taskId: '2',
        )).thenAnswer(
      (_) async => false,
    );

    when(() => _repository.claimTask(
          taskId: any(
            named: 'taskId',
            that: isNot(contains('2')),
          ),
        )).thenAnswer(
      (_) async => true,
    );
  });

  blocTest<UnassignedTasksCubit, UnassignedTasksState>(
    'starts on empty state',
    build: () => UnassignedTasksCubit(
      repository: _repository,
    ),
    verify: (c) => expect(c.state, UnassignedTasksState()),
  ); // starts on empty state

  blocTest<UnassignedTasksCubit, UnassignedTasksState>(
    'should load tasks without customer id',
    build: () => UnassignedTasksCubit(
      repository: _repository,
    ),
    act: (c) => c.load(),
    expect: () => [
      UnassignedTasksState(busy: true),
      UnassignedTasksState(
        tasks: _repositoryList,
      ),
    ],
    verify: (c) {
      verify(() => _repository.listUnassignedTasks(
            fetchCustomersData: true,
            forceRefresh: false,
          )).called(1);
    },
  ); // should load tasks

  blocTest<UnassignedTasksCubit, UnassignedTasksState>(
    'should load tasks with customer id',
    build: () => UnassignedTasksCubit(
      repository: _repository,
      customerId: _fixedCustomer.id,
    ),
    act: (c) => c.load(),
    expect: () => [
      UnassignedTasksState(
        customerId: _fixedCustomer.id,
        busy: true,
      ),
      UnassignedTasksState(
        customerId: _fixedCustomer.id,
        tasks: _customerList,
      )
    ],
    verify: (c) {
      verify(() => _repository.listUnassignedTasks(
            customerId: _fixedCustomer.id,
          )).called(1);
    },
  );

  group('Error handling', () {
    setUp(() {
      when(
        () => _repository.listUnassignedTasks(),
      ).thenThrow(
        NetException(message: 'Error'),
      );
    });

    blocTest<UnassignedTasksCubit, UnassignedTasksState>(
      'should deal with simple exceptions',
      build: () => UnassignedTasksCubit(
        repository: _repository,
      ),
      act: (c) => c.load(),
      expect: () => [
        UnassignedTasksState(busy: true),
        UnassignedTasksState(
          errorStatus: UnassignedTasksErrorStatus.network,
        ),
      ],
      verify: (c) {
        verify(() => _repository.listUnassignedTasks()).called(1);
      },
    ); // should deal with simple exceptions
  });

  group('claim tests', _claimTests);
}

void _claimTests() {
  blocTest<UnassignedTasksCubit, UnassignedTasksState>(
    'should claim tasks',
    build: () => UnassignedTasksCubit(repository: _repository),
    seed: () => UnassignedTasksState(tasks: _repositoryList),
    act: (c) => c.claimTasks(tasksIds: ['1', '2', '3']),
    expect: () => [
      UnassignedTasksState(
        tasks: _repositoryList,
        busy: true,
      ),
      UnassignedTasksState(
        tasks: _repositoryList.where((e) => e.id != '1' && e.id != '3'),
        action: UnassignedTasksAction.claimed,
      ),
    ],
    verify: (c) {
      verifyNever(() => _repository.claimTask(taskId: '0'));
      verify(() => _repository.claimTask(taskId: '1')).called(1);
      verify(() => _repository.claimTask(taskId: '2')).called(1);
      verify(() => _repository.claimTask(taskId: '3')).called(1);
      verifyNever(() => _repository.claimTask(taskId: '4'));
      verifyNever(() => _repository.claimTask(taskId: '5'));
    },
  ); // should claim tasks
  group('Exception handling', () {
    setUp(() {
      when(
        () => _repository.claimTask(taskId: '1'),
      ).thenThrow(
        NetException(),
      );
    });

    blocTest<UnassignedTasksCubit, UnassignedTasksState>(
      'should handle exception on claim tasks',
      build: () => UnassignedTasksCubit(repository: _repository),
      seed: () => UnassignedTasksState(tasks: _repositoryList),
      act: (c) => c.claimTasks(tasksIds: ['1', '2', '3']),
      expect: () => [
        UnassignedTasksState(
          tasks: _repositoryList,
          busy: true,
        ),
        UnassignedTasksState(
          tasks: _repositoryList,
          errorStatus: UnassignedTasksErrorStatus.network,
        ),
      ],
      verify: (c) {
        verifyNever(() => _repository.claimTask(taskId: '0'));
        verify(() => _repository.claimTask(taskId: '1')).called(1);
        verifyNever(() => _repository.claimTask(taskId: '2'));
        verifyNever(() => _repository.claimTask(taskId: '3'));
        verifyNever(() => _repository.claimTask(taskId: '4'));
        verifyNever(() => _repository.claimTask(taskId: '5'));
      },
    );
  });
}
