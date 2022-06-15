import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/branch_activation.dart';
import 'package:layer_sdk/presentation_layer/utils.dart';
import 'package:mocktail/mocktail.dart';

class MockBranchActivationRepository extends Mock
    implements BranchActivationRepositoryInterface {}

class MockBranchActivationResponse extends Mock
    implements BranchActivationResponse {}

late MockBranchActivationRepository _repository;
late CheckBranchActivationCodeUseCase _useCase;
late MockBranchActivationResponse _branchActivationResponse;

final _code = ActivationCodeUtils().generateActivationCode(6);

void main() {
  setUp(() {
    _repository = MockBranchActivationRepository();
    _useCase = CheckBranchActivationCodeUseCase(repository: _repository);

    _branchActivationResponse = MockBranchActivationResponse();

    when(
      () => _repository.checkBranchActivationCode(
        code: any(named: 'code'),
        useOtp: any(named: 'useOtp'),
      ),
    ).thenAnswer((_) async => _branchActivationResponse);
  });

  test('Should return a branch activation response', () async {
    final result = await _useCase(code: _code, useOTP: true);

    expect(result, _branchActivationResponse);

    verify(
      () => _repository.checkBranchActivationCode(code: _code, useOtp: true),
    ).called(1);
  });
}
