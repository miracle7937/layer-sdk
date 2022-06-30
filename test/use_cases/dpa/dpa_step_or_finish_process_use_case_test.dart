import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/dpa.dart';
import 'package:mocktail/mocktail.dart';

class MockDPARepository extends Mock implements DPARepositoryInterface {}

late MockDPARepository _repository;
late DPAStepOrFinishProcessUseCase _useCase;
late DPAProcess pre;
late DPAProcess post;

void main() {
  EquatableConfig.stringify = true;

  setUp(() {
    _repository = MockDPARepository();
    _useCase = DPAStepOrFinishProcessUseCase(
      repository: _repository,
    );

    final preProcessName = 'process';
    final postProcessName = 'post';

    pre = DPAProcess(
      processName: preProcessName,
    );

    post = DPAProcess(
      processName: postProcessName,
    );

    when(
      () => _repository.stepOrFinishProcess(
        process: pre,
      ),
    ).thenAnswer(
      (_) async => post,
    );
  });

  test('Should return correct DPAProcess', () async {
    final result = await _useCase(
      process: pre,
    );

    expect(result, post);

    verify(
      () => _repository.stepOrFinishProcess(
        process: pre,
      ),
    ).called(1);
  });
}
