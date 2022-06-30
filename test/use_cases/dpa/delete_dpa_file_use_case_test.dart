import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/dpa.dart';
import 'package:mocktail/mocktail.dart';

class MockDPARepository extends Mock implements DPARepositoryInterface {}

late MockDPARepository _repository;
late DeleteDPAFileUseCase _deleteDPAFileUseCase;
late DPAVariable preDeletionVariable;
late DPAVariable postDeletionVariable;
late DPAProcess process;

void main() {
  EquatableConfig.stringify = true;

  setUp(() {
    _repository = MockDPARepository();
    _deleteDPAFileUseCase = DeleteDPAFileUseCase(
      repository: _repository,
    );

    final preDeletionId = 'preDeletion';
    final postDeletionId = 'postDeletion';
    final processName = 'process';

    preDeletionVariable = DPAVariable(
      id: preDeletionId,
      property: DPAVariableProperty(),
    );

    postDeletionVariable = DPAVariable(
      id: postDeletionId,
      property: DPAVariableProperty(),
    );

    process = DPAProcess(
      processName: processName,
    );

    when(
      () => _repository.deleteFile(
        variable: preDeletionVariable,
        process: process,
      ),
    ).thenAnswer(
      (_) async => postDeletionVariable,
    );
  });

  test('Should return correct DPAVariable', () async {
    final result = await _deleteDPAFileUseCase(
      process: process,
      variable: preDeletionVariable,
    );

    expect(result, postDeletionVariable);

    verify(
      () => _repository.deleteFile(
        process: process,
        variable: preDeletionVariable,
      ),
    ).called(1);
  });
}
