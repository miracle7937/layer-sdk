import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/dpa.dart';
import 'package:mocktail/mocktail.dart';

class MockDPARepository extends Mock implements DPARepositoryInterface {}

late MockDPARepository _repository;
late ListUnassignedTasksUseCase _useCase;
late List<DPATask> _mockedTasks;

void main() {
  EquatableConfig.stringify = true;

  setUp(() {
    _repository = MockDPARepository();
    _useCase = ListUnassignedTasksUseCase(
      repository: _repository,
    );

    _mockedTasks = List.generate(
      5,
      (index) => DPATask(
        name: 'Task $index',
        id: index.toString(),
        status: DPAStatus.active,
      ),
    );

    when(
      () => _repository.listUnassignedTasks(),
    ).thenAnswer(
      (_) async => _mockedTasks,
    );
  });

  test('Should return correct tasks', () async {
    final response = await _useCase();

    expect(response, _mockedTasks);

    verify(
      () => _repository.listUnassignedTasks(),
    ).called(1);
  });
}
