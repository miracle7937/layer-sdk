import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/dpa.dart';
import 'package:mocktail/mocktail.dart';

class MockDPARepository extends Mock implements DPARepositoryInterface {}

late MockDPARepository _repository;
late LoadTaskByIdUseCase _useCase;
late String taskId;
late DPATask resultTask;

void main() {
  EquatableConfig.stringify = true;

  setUp(() {
    _repository = MockDPARepository();
    _useCase = LoadTaskByIdUseCase(
      repository: _repository,
    );

    taskId = 'thisisatest';

    resultTask = DPATask(
      id: 'thisisatest',
      status: DPAStatus.active,
      name: 'ayylmao',
    );

    when(
      () => _repository.getTask(
        processInstanceId: taskId,
      ),
    ).thenAnswer(
      (_) async => resultTask,
    );
  });

  test('Should return correct task', () async {
    final response = await _useCase(
      processInstanceId: taskId,
    );

    expect(response, resultTask);

    verify(
      () => _repository.getTask(
        processInstanceId: taskId,
      ),
    ).called(1);
  });
}
