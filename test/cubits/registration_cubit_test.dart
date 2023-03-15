import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/data_layer/repositories.dart';
import 'package:layer_sdk/data_layer/strategies.dart';
import 'package:layer_sdk/presentation_layer/cubits.dart';
import 'package:layer_sdk/presentation_layer/errors.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockRegistrationStep extends Mock implements RegistrationStep<String> {}

class MockRegistrationFormValidationStrategy extends Mock
    implements RegistrationFormValidationStrategy {}

class MockRegistrationStepValidationStrategy extends Mock
    implements RegistrationStepValidationStrategy {}

class MockSecondFactorRepository extends Mock
    implements SecondFactorRepository {}

late MockRegistrationStep registrationStepMock;
late MockRegistrationFormValidationStrategy formValidationStrategyMock;
late MockRegistrationStepValidationStrategy stepValidationStrategyMock;
late MockSecondFactorRepository secondFactorRepositoryMock;

final String stepParameters = 'parameters';
final String mobileNumber = '123123123';
final int otpId = 12;
final String token = 'token';

final RegistrationFormValidationError mobileNumberError =
    RegistrationFormValidationError.fieldRequired;
final Map<RegistrationInputType, RegistrationFormValidationError> formErrors = {
  RegistrationInputType.mobileNumber: mobileNumberError,
};
final RegistrationState stepState = RegistrationState(
  stepErrorMessage: 'stepError',
  formErrors: formErrors,
  currentStep: 1,
  busy: true,
);

void main() {
  EquatableConfig.stringify = true;
  setUpAll(() {
    registerFallbackValue(RegistrationState());
    registerFallbackValue(RegistrationInputType.cardNumber);
    registerFallbackValue(MockRegistrationStep());
  });
  setUp(() {
    registrationStepMock = MockRegistrationStep();
    formValidationStrategyMock = MockRegistrationFormValidationStrategy();
    stepValidationStrategyMock = MockRegistrationStepValidationStrategy();
    secondFactorRepositoryMock = MockSecondFactorRepository();
    when(() => registrationStepMock.call(
          parameters: stepParameters,
          state: any(named: 'state'),
        )).thenAnswer((_) async => stepState);

    when(
      () => formValidationStrategyMock
          .isApplicable(RegistrationInputType.mobileNumber),
    ).thenReturn(true);
    when(
      () => formValidationStrategyMock.isApplicable(
        any(that: isNot(RegistrationInputType.mobileNumber)),
      ),
    ).thenReturn(false);
    when(
      () => formValidationStrategyMock.validate(mobileNumber),
    ).thenReturn(mobileNumberError);

    when(
      () => stepValidationStrategyMock.isApplicable(any()),
    ).thenReturn(true);
    when(
      () => stepValidationStrategyMock.validate(stepParameters),
    ).thenReturn(true);

    when(
      () => secondFactorRepositoryMock.resendCustomerOTP(
        otpId: any(named: 'otpId'),
        token: any(named: 'token'),
      ),
    ).thenAnswer((_) async => null);
  });

  blocTest<RegistrationCubit, RegistrationState>(
    'Should start with an empty state.',
    build: () => RegistrationCubit(
      registrationSteps: [registrationStepMock],
      formValidationStrategies: [formValidationStrategyMock],
      stepValidationStrategies: [stepValidationStrategyMock],
      secondFactorRepository: secondFactorRepositoryMock,
    ),
    verify: (c) => expect(c.state, RegistrationState()),
  );

  blocTest<RegistrationCubit, RegistrationState>(
    'Should perform current step.',
    build: () => RegistrationCubit(
      registrationSteps: [registrationStepMock],
      formValidationStrategies: [formValidationStrategyMock],
      stepValidationStrategies: [stepValidationStrategyMock],
      secondFactorRepository: secondFactorRepositoryMock,
    ),
    seed: () => RegistrationState(currentParameters: stepParameters),
    act: (c) => c.performCurrentStep(),
    expect: () => [
      RegistrationState(
        busy: true,
        currentParameters: stepParameters,
      ),
      stepState.copyWith(busy: false),
    ],
    verify: (c) {
      verify(() => registrationStepMock.call(
            parameters: stepParameters,
            state: RegistrationState(
              busy: true,
              currentParameters: stepParameters,
            ),
          )).called(1);
    },
  );

  blocTest<RegistrationCubit, RegistrationState>(
    'Should update current parameters.',
    build: () => RegistrationCubit(
      registrationSteps: [registrationStepMock],
      formValidationStrategies: [formValidationStrategyMock],
      stepValidationStrategies: [stepValidationStrategyMock],
      secondFactorRepository: secondFactorRepositoryMock,
    ),
    act: (c) => c.updateCurrentParameters(stepParameters),
    expect: () => [
      RegistrationState(
        stepValid: true,
        currentParameters: stepParameters,
      ),
    ],
    verify: (c) {
      verify(() => stepValidationStrategyMock.validate(stepParameters))
          .called(1);
    },
  );

  blocTest<RegistrationCubit, RegistrationState>(
    'Should validate data.',
    build: () => RegistrationCubit(
      registrationSteps: [registrationStepMock],
      formValidationStrategies: [formValidationStrategyMock],
      stepValidationStrategies: [stepValidationStrategyMock],
      secondFactorRepository: secondFactorRepositoryMock,
    ),
    act: (c) => c.validateFormField(
      type: RegistrationInputType.mobileNumber,
      value: mobileNumber,
    ),
    expect: () => [
      RegistrationState(formErrors: formErrors),
    ],
    verify: (c) {
      verify(
        () => formValidationStrategyMock
            .isApplicable(RegistrationInputType.mobileNumber),
      ).called(1);
      verify(() => formValidationStrategyMock.validate(
            mobileNumber,
          )).called(1);
    },
  );

  test('Should throw when validation strategy is not found.', () async {
    final cubit = RegistrationCubit(
      registrationSteps: [registrationStepMock],
      formValidationStrategies: [formValidationStrategyMock],
      stepValidationStrategies: [stepValidationStrategyMock],
      secondFactorRepository: secondFactorRepositoryMock,
    );

    NoApplicableStrategyError? error;
    try {
      await cubit.validateFormField(
        type: RegistrationInputType.cardNumber,
        value: mobileNumber,
      );
      // TODO: is there a way to test if the error is thrown
      // without suppressing the linter?
      // ignore: avoid_catching_errors
    } on NoApplicableStrategyError catch (e) {
      error = e;
    }
    expect(error, isNotNull);
    verify(
      () => formValidationStrategyMock
          .isApplicable(RegistrationInputType.cardNumber),
    ).called(1);
    verifyNever(() => formValidationStrategyMock.validate(
          mobileNumber,
        ));
  });

  blocTest<RegistrationCubit, RegistrationState>(
    'Should resend OTP',
    build: () => RegistrationCubit(
      registrationSteps: [registrationStepMock],
      formValidationStrategies: [formValidationStrategyMock],
      stepValidationStrategies: [stepValidationStrategyMock],
      secondFactorRepository: secondFactorRepositoryMock,
    ),
    act: (c) => c.resendOTP(
      otpId: otpId,
      token: token,
    ),
    expect: () => [
      RegistrationState(busy: true),
      RegistrationState(busy: false),
    ],
    verify: (c) {
      verify(
        () => secondFactorRepositoryMock.resendCustomerOTP(
          otpId: otpId,
          token: token,
        ),
      ).called(1);
    },
  );
  blocTest<RegistrationCubit, RegistrationState>(
    'Should go back a step',
    build: () => RegistrationCubit(
      registrationSteps: [registrationStepMock],
      formValidationStrategies: [formValidationStrategyMock],
      stepValidationStrategies: [stepValidationStrategyMock],
      secondFactorRepository: secondFactorRepositoryMock,
    ),
    act: (c) => c.backToPreviousStep(),
    seed: () => RegistrationState(currentStep: 1),
    expect: () => [
      RegistrationState(currentStep: 0),
    ],
  );
}
