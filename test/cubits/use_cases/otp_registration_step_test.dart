import 'package:equatable/equatable.dart';
import 'package:layer_sdk/_migration/business_layer/business_layer.dart';
import 'package:layer_sdk/_migration/data_layer/data_layer.dart';
import 'package:layer_sdk/data_layer/network.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockSecondFactorRepository extends Mock
    implements SecondFactorRepository {}

late SecondFactorRepository repositoryMock;

void main() {
  EquatableConfig.stringify = true;
  late OTPRegistrationStep otpRegistrationStep;

  final user = User(
    id: 'id',
    username: 'username',
    firstName: 'firstName',
    lastName: 'lastName',
    status: UserStatus.active,
    token: 'token',
    accessPin: 'accessPin',
    imageURL: null,
  );

  final validOTP = 'validOtp';
  final invalidOTP = 'invalidOtp';

  final validRegistrationResponse = RegistrationResponse(
    user: user,
    secondFactorVerification: SecondFactorVerification(
      id: 1,
      type: SecondFactorType.otp,
      value: validOTP,
    ),
  );

  final invalidRegistrationResponse = RegistrationResponse(
    user: user,
    secondFactorVerification: SecondFactorVerification(
      id: 1,
      type: SecondFactorType.otp,
      value: invalidOTP,
    ),
  );

  final exception = NetException(message: 'Message');

  setUp(() {
    repositoryMock = MockSecondFactorRepository();
    otpRegistrationStep = OTPRegistrationStep(repository: repositoryMock);

    when(
      () => repositoryMock.verifyCustomerSecondFactor(
        secondFactor: validRegistrationResponse.secondFactorVerification!,
        token: user.token!,
      ),
    ).thenAnswer((_) async => null);

    when(
      () => repositoryMock.verifyCustomerSecondFactor(
        secondFactor: invalidRegistrationResponse.secondFactorVerification!,
        token: user.token!,
      ),
    ).thenThrow(exception);
  });

  test('Should verify the OTP successfully', () async {
    final result = await otpRegistrationStep(
      parameters: validRegistrationResponse,
      state: RegistrationState(),
    );

    expect(result, RegistrationState(currentStep: 1));
    verify(() => repositoryMock.verifyCustomerSecondFactor(
          secondFactor: validRegistrationResponse.secondFactorVerification!,
          token: validRegistrationResponse.user.token!,
        )).called(1);
  });

  test('Should return state with error', () async {
    final result = await otpRegistrationStep(
      parameters: invalidRegistrationResponse,
      state: RegistrationState(),
    );

    expect(
      result,
      RegistrationState(
        stepErrorMessage: exception.message,
        stepError: RegistrationStateError.generic,
      ),
    );
    verify(() => repositoryMock.verifyCustomerSecondFactor(
          secondFactor: invalidRegistrationResponse.secondFactorVerification!,
          token: invalidRegistrationResponse.user.token!,
        )).called(1);
  });
}
