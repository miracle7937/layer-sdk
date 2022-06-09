import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/dpa.dart';
import 'package:mocktail/mocktail.dart';

class MockDPARepository extends Mock implements DPARepositoryInterface {}

late MockDPARepository _repository;
late ClaimDPATaskUseCase _claimDPATaskUseCase;
late String trueTaskId;
late String falseTaskId;

void main() {
  EquatableConfig.stringify = true;

  setUp(() {
    _repository = MockDPARepository();
    _claimDPATaskUseCase = ClaimDPATaskUseCase(
      repository: _repository,
    );
    trueTaskId = 'true';
    falseTaskId = 'false';

    when(
      () => _repository.claimTask(
        taskId: trueTaskId,
      ),
    ).thenAnswer(
      (_) async => true,
    );

    when(
      () => _repository.claimTask(
        taskId: falseTaskId,
      ),
    ).thenAnswer(
      (_) async => false,
    );
  });

  test('Should return true', () async {
    final response = await _claimDPATaskUseCase(
      taskId: trueTaskId,
    );

    expect(response, true);

    verify(
      () => _repository.claimTask(
        taskId: trueTaskId,
      ),
    ).called(1);
  });

  test('Should return false', () async {
    final response = await _claimDPATaskUseCase(
      taskId: falseTaskId,
    );

    expect(response, false);

    verify(
      () => _repository.claimTask(
        taskId: falseTaskId,
      ),
    ).called(1);
  });
}
