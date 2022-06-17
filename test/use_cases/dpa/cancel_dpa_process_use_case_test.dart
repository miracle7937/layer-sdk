import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/dpa.dart';
import 'package:mocktail/mocktail.dart';

class MockDPARepository extends Mock implements DPARepositoryInterface {}

late MockDPARepository _repository;
late CancelDPAProcessUseCase _cancelDpaProcessUseCase;
late DPAProcess _trueProcess;
late DPAProcess _falseProcess;

void main() {
  EquatableConfig.stringify = true;

  setUp(() {
    _repository = MockDPARepository();
    _cancelDpaProcessUseCase = CancelDPAProcessUseCase(
      repository: _repository,
    );
    _trueProcess = DPAProcess(
      processName: 'true',
    );
    _falseProcess = DPAProcess(
      processName: 'false',
    );

    when(
      () => _repository.cancelProcess(
        process: _trueProcess,
      ),
    ).thenAnswer(
      (_) async => true,
    );

    when(
      () => _repository.cancelProcess(
        process: _falseProcess,
      ),
    ).thenAnswer(
      (_) async => false,
    );
  });

  test('Should return true', () async {
    final response = await _cancelDpaProcessUseCase(
      process: _trueProcess,
    );

    expect(response, true);

    verify(
      () => _repository.cancelProcess(
        process: _trueProcess,
      ),
    ).called(1);
  });

  test('Should return false', () async {
    final response = await _cancelDpaProcessUseCase(
      process: _falseProcess,
    );

    expect(response, false);

    verify(
      () => _repository.cancelProcess(
        process: _falseProcess,
      ),
    ).called(1);
  });
}
