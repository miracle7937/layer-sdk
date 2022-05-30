import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/business_layer/business_layer.dart';
import 'package:layer_sdk/data_layer/data_layer.dart';
import 'package:layer_sdk/migration/data_layer/network.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockDPARepository extends Mock implements DPARepository {}

final _repositoryList = <DPATask>[];

late MockDPARepository _repository;

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

  setUpAll(() {
    _repository = MockDPARepository();

    when(
      () => _repository.listHistory(),
    ).thenAnswer(
      (_) async => _repositoryList.toList(),
    );
  });

  blocTest<TaskHistoryCubit, TaskHistoryState>(
    'starts on empty state',
    build: () => TaskHistoryCubit(
      repository: _repository,
    ),
    verify: (c) => expect(c.state, TaskHistoryState()),
  ); // starts on empty state

  blocTest<TaskHistoryCubit, TaskHistoryState>(
    'should load tasks',
    build: () => TaskHistoryCubit(
      repository: _repository,
    ),
    act: (c) => c.load(),
    expect: () => [
      TaskHistoryState(busy: true),
      TaskHistoryState(
        tasks: _repositoryList,
      ),
    ],
    verify: (c) {
      verify(() => _repository.listHistory(
            fetchCustomersData: true,
            forceRefresh: false,
          )).called(1);
    },
  ); // should load tasks

  group('Error handling', () {
    setUp(() {
      when(
        () => _repository.listHistory(),
      ).thenThrow(
        NetException(message: 'Error'),
      );
    });

    blocTest<TaskHistoryCubit, TaskHistoryState>(
      'should deal with simple exceptions',
      build: () => TaskHistoryCubit(
        repository: _repository,
      ),
      act: (c) => c.load(),
      expect: () => [
        TaskHistoryState(busy: true),
        TaskHistoryState(
          errorStatus: TaskHistoryErrorStatus.network,
        ),
      ],
      verify: (c) {
        verify(() => _repository.listHistory()).called(1);
      },
    ); // should deal with simple exceptions
  });
}
