import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/dpa.dart';
import 'package:mocktail/mocktail.dart';

class MockDPARepository extends Mock implements DPARepositoryInterface {}

late MockDPARepository _repository;
late DownloadDPAFileUseCase _downloadDPAFileUseCase;
late DPAVariable mockedVariable;
late DPAProcess process;
late String response;

void main() {
  EquatableConfig.stringify = true;

  setUp(() {
    _repository = MockDPARepository();
    _downloadDPAFileUseCase = DownloadDPAFileUseCase(
      repository: _repository,
    );

    final preDeletionId = 'preDeletion';
    final processName = 'process';

    response = 'thisisatest';

    mockedVariable = DPAVariable(
      id: preDeletionId,
      property: DPAVariableProperty(),
    );

    process = DPAProcess(
      processName: processName,
    );

    when(
      () => _repository.downloadFile(
        variable: mockedVariable,
        process: process,
      ),
    ).thenAnswer(
      (_) async => response,
    );
  });

  test('Should return correct value', () async {
    final result = await _downloadDPAFileUseCase(
      process: process,
      variable: mockedVariable,
    );

    expect(result, response);

    verify(
      () => _repository.downloadFile(
        process: process,
        variable: mockedVariable,
      ),
    ).called(1);
  });
}
