import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/dpa.dart';
import 'package:mocktail/mocktail.dart';

class MockDPARepository extends Mock implements DPARepositoryInterface {}

late MockDPARepository _repository;
late FinishTaskUseCase _useCase;
late DPATask trueTask;
late DPATask falseTask;

void main() {
  EquatableConfig.stringify = true;

  setUp(() {
    _repository = MockDPARepository();
    _useCase = FinishTaskUseCase(
      repository: _repository,
    );
    trueTask = DPATask(
      id: 'true',
      name: 'task',
      status: DPAStatus.active,
    );

    falseTask = DPATask(
      id: 'false',
      name: 'task false',
      status: DPAStatus.failed,
    );

    when(
      () => _repository.finishTask(
        task: trueTask,
      ),
    ).thenAnswer(
      (_) async => true,
    );

    when(
      () => _repository.finishTask(
        task: falseTask,
      ),
    ).thenAnswer(
      (_) async => false,
    );
  });

  test('Should return true', () async {
    final response = await _useCase(
      task: trueTask,
    );

    expect(response, true);

    verify(
      () => _repository.finishTask(
        task: trueTask,
      ),
    ).called(1);
  });

  test('Should return false', () async {
    final response = await _useCase(
      task: falseTask,
    );

    expect(response, false);

    verify(
      () => _repository.finishTask(
        task: falseTask,
      ),
    ).called(1);
  });
}
