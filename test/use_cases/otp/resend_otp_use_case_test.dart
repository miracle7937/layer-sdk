import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/data_layer/network.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/features/branch_activation.dart';
import 'package:mocktail/mocktail.dart';

class MockOTPRepository extends Mock implements OTPRepositoryInterface {}

class MockUser extends Mock implements User {}

late MockOTPRepository _repository;
late ResendOTPUseCase _useCase;
final NetResponse _response = NetResponse(statusCode: 200);

final _otpId = 1;

void main() {
  setUp(() {
    _repository = MockOTPRepository();
    _useCase = ResendOTPUseCase(repository: _repository);

    when(
      () => _repository.resendCustomerOTP(
        otpId: any(named: 'otpId'),
      ),
    ).thenAnswer((_) async => _response);
  });

  test('Should resend the OTP', () async {
    final result = await _useCase(otpId: _otpId);

    expect(result, _response);

    verify(
      () => _repository.resendCustomerOTP(otpId: _otpId),
    ).called(1);
  });
}
