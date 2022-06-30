import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/data_layer/network.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:layer_sdk/presentation_layer/cubits.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockLoadDPAHistoryUseCase extends Mock implements LoadDPAHistoryUseCase {}

final _taskList = <DPATask>[];

late MockLoadDPAHistoryUseCase _useCase;

void main() {
  EquatableConfig.stringify = true;

  for (var i = 0; i < 23; ++i) {
    _taskList.add(
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
    _useCase = MockLoadDPAHistoryUseCase();

    when(
      () => _useCase(),
    ).thenAnswer(
      (_) async => _taskList,
    );
  });

  blocTest<TaskHistoryCubit, TaskHistoryState>(
    'starts on empty state',
    build: () => TaskHistoryCubit(
      dpaHistoryUseCase: _useCase,
    ),
    verify: (c) => expect(c.state, TaskHistoryState()),
  ); // starts on empty state

  blocTest<TaskHistoryCubit, TaskHistoryState>(
    'should load tasks',
    build: () => TaskHistoryCubit(
      dpaHistoryUseCase: _useCase,
    ),
    act: (c) => c.load(),
    expect: () => [
      TaskHistoryState(busy: true),
      TaskHistoryState(
        tasks: _taskList,
      ),
    ],
    verify: (c) {
      verify(() => _useCase(
            fetchCustomersData: true,
            forceRefresh: false,
          )).called(1);
    },
  ); // should load tasks

  group('Error handling', () {
    setUp(() {
      when(
        () => _useCase(),
      ).thenThrow(
        NetException(message: 'Error'),
      );
    });

    blocTest<TaskHistoryCubit, TaskHistoryState>(
      'should deal with simple exceptions',
      build: () => TaskHistoryCubit(
        dpaHistoryUseCase: _useCase,
      ),
      act: (c) => c.load(),
      expect: () => [
        TaskHistoryState(busy: true),
        TaskHistoryState(
          errorStatus: TaskHistoryErrorStatus.network,
        ),
      ],
      verify: (c) {
        verify(() => _useCase()).called(1);
      },
    ); // should deal with simple exceptions
  });
}
