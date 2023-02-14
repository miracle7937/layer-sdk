import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/dpa.dart';
import 'package:mocktail/mocktail.dart';

class MockDPARepository extends Mock implements DPARepositoryInterface {}

late MockDPARepository _repository;
late CancelDPAProcessUseCase _cancelDpaProcessUseCase;
late String _trueKey;
late String _falseKey;

void main() {
  EquatableConfig.stringify = true;

  setUp(() {
    _repository = MockDPARepository();
    _cancelDpaProcessUseCase = CancelDPAProcessUseCase(
      repository: _repository,
    );
    _trueKey = 'true';
    _falseKey = 'false';

    when(
      () => _repository.cancelProcess(
        processInstanceId: _trueKey,
      ),
    ).thenAnswer(
      (_) async => true,
    );

    when(
      () => _repository.cancelProcess(
        processInstanceId: _falseKey,
      ),
    ).thenAnswer(
      (_) async => false,
    );
  });

  test('Should return true', () async {
    final response = await _cancelDpaProcessUseCase(
      processInstanceId: _trueKey,
    );

    expect(response, true);

    verify(
      () => _repository.cancelProcess(
        processInstanceId: _trueKey,
      ),
    ).called(1);
  });

  test('Should return false', () async {
    final response = await _cancelDpaProcessUseCase(
      processInstanceId: _falseKey,
    );

    expect(response, false);

    verify(
      () => _repository.cancelProcess(
        processInstanceId: _falseKey,
      ),
    ).called(1);
  });
}
