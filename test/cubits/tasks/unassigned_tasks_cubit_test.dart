import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/data_layer/network.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:layer_sdk/presentation_layer/cubits.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockListUnassignedTasksUseCase extends Mock
    implements ListUnassignedTasksUseCase {}

class MockClaimDPATaskUseCase extends Mock implements ClaimDPATaskUseCase {}

final _repositoryList = <DPATask>[];
final _customerList = <DPATask>[];

late MockListUnassignedTasksUseCase _listUnassignedTasksUseCase;

late MockClaimDPATaskUseCase _claimDPATaskUseCase;

final _fixedCustomer = Customer(
  id: 'Fixed',
  firstName: 'Fixed costumer',
  status: CustomerStatus.active,
  type: CustomerType.personal,
);

UnassignedTasksCubit create({
  String? customerId,
}) =>
    UnassignedTasksCubit(
      claimDPATaskUseCase: _claimDPATaskUseCase,
      unassignedTasksUseCase: _listUnassignedTasksUseCase,
      customerId: customerId,
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
    _listUnassignedTasksUseCase = MockListUnassignedTasksUseCase();
    _claimDPATaskUseCase = MockClaimDPATaskUseCase();

    when(
      () => _listUnassignedTasksUseCase(),
    ).thenAnswer(
      (_) async => _repositoryList.toList(),
    );

    when(
      () => _listUnassignedTasksUseCase(
        customerId: _fixedCustomer.id,
      ),
    ).thenAnswer(
      (_) async => _customerList.toList(),
    );

    when(() => _claimDPATaskUseCase(
          taskId: '2',
        )).thenAnswer(
      (_) async => false,
    );

    when(() => _claimDPATaskUseCase(
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
    build: create,
    verify: (c) => expect(c.state, UnassignedTasksState()),
  ); // starts on empty state

  blocTest<UnassignedTasksCubit, UnassignedTasksState>(
    'should load tasks without customer id',
    build: create,
    act: (c) => c.load(),
    expect: () => [
      UnassignedTasksState(busy: true),
      UnassignedTasksState(
        tasks: _repositoryList,
      ),
    ],
    verify: (c) {
      verify(() => _listUnassignedTasksUseCase(
            fetchCustomersData: true,
            forceRefresh: false,
          )).called(1);
    },
  ); // should load tasks

  blocTest<UnassignedTasksCubit, UnassignedTasksState>(
    'should load tasks with customer id',
    build: () => create(
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
      verify(() => _listUnassignedTasksUseCase(
            customerId: _fixedCustomer.id,
          )).called(1);
    },
  );

  group('Error handling', () {
    setUp(() {
      when(
        () => _listUnassignedTasksUseCase(),
      ).thenThrow(
        NetException(message: 'Error'),
      );
    });

    blocTest<UnassignedTasksCubit, UnassignedTasksState>(
      'should deal with simple exceptions',
      build: create,
      act: (c) => c.load(),
      expect: () => [
        UnassignedTasksState(busy: true),
        UnassignedTasksState(
          errorStatus: UnassignedTasksErrorStatus.network,
        ),
      ],
      verify: (c) {
        verify(() => _listUnassignedTasksUseCase()).called(1);
      },
    ); // should deal with simple exceptions
  });

  group('claim tests', _claimTests);
}

void _claimTests() {
  blocTest<UnassignedTasksCubit, UnassignedTasksState>(
    'should claim tasks',
    build: create,
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
      verifyNever(() => _claimDPATaskUseCase(taskId: '0'));
      verify(() => _claimDPATaskUseCase(taskId: '1')).called(1);
      verify(() => _claimDPATaskUseCase(taskId: '2')).called(1);
      verify(() => _claimDPATaskUseCase(taskId: '3')).called(1);
      verifyNever(() => _claimDPATaskUseCase(taskId: '4'));
      verifyNever(() => _claimDPATaskUseCase(taskId: '5'));
    },
  ); // should claim tasks
  group('Exception handling', () {
    setUp(() {
      when(
        () => _claimDPATaskUseCase(taskId: '1'),
      ).thenThrow(
        NetException(),
      );
    });

    blocTest<UnassignedTasksCubit, UnassignedTasksState>(
      'should handle exception on claim tasks',
      build: create,
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
        verifyNever(() => _claimDPATaskUseCase(taskId: '0'));
        verify(() => _claimDPATaskUseCase(taskId: '1')).called(1);
        verifyNever(() => _claimDPATaskUseCase(taskId: '2'));
        verifyNever(() => _claimDPATaskUseCase(taskId: '3'));
        verifyNever(() => _claimDPATaskUseCase(taskId: '4'));
        verifyNever(() => _claimDPATaskUseCase(taskId: '5'));
      },
    );
  });
}
