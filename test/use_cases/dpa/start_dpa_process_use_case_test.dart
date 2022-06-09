import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/dpa.dart';
import 'package:mocktail/mocktail.dart';

class MockDPARepository extends Mock implements DPARepositoryInterface {}

late MockDPARepository _repository;
late StartDPAProcessUseCase _useCase;
late String processId;
late DPAProcess resultProcess;

void main() {
  EquatableConfig.stringify = true;

  setUp(() {
    _repository = MockDPARepository();
    _useCase = StartDPAProcessUseCase(
      repository: _repository,
    );

    processId = 'processId';

    resultProcess = DPAProcess(
      processName: processId,
    );

    when(
      () => _repository.startProcess(
        id: processId,
        variables: [],
      ),
    ).thenAnswer(
      (_) async => resultProcess,
    );
  });

  test('Should return the correct DPAProcess', () async {
    final result = await _useCase(
      id: processId,
      variables: [],
    );

    expect(result, resultProcess);

    verify(
      () => _repository.startProcess(
        id: processId,
        variables: [],
      ),
    ).called(1);
  });
}
