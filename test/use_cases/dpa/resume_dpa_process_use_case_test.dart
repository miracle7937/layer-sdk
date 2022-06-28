import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/dpa.dart';
import 'package:mocktail/mocktail.dart';

class MockDPARepository extends Mock implements DPARepositoryInterface {}

late MockDPARepository _repository;
late ResumeDPAProcessUsecase _useCase;
late String taskId;
late DPAProcess resultProcess;

void main() {
  EquatableConfig.stringify = true;

  setUp(() {
    _repository = MockDPARepository();
    _useCase = ResumeDPAProcessUsecase(
      repository: _repository,
    );

    taskId = 'thisisatest';

    resultProcess = DPAProcess(
      processName: 'Thisisatest',
    );

    when(
      () => _repository.resumeProcess(
        id: taskId,
      ),
    ).thenAnswer(
      (_) async => resultProcess,
    );
  });

  test('Should return correct DPAProcess', () async {
    final response = await _useCase(
      id: taskId,
    );

    expect(response, resultProcess);

    verify(
      () => _repository.resumeProcess(
        id: taskId,
      ),
    ).called(1);
  });
}
