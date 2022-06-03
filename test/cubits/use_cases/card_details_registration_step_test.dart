import 'package:layer_sdk/_migration/business_layer/business_layer.dart';
import 'package:layer_sdk/_migration/data_layer/data_layer.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockRegistrationEncryptionStrategy extends Mock
    implements
        RegistrationEncryptionStrategy<MobileAndCardRegistrationParameters> {}

class MockRegistrationRepository extends Mock
    implements RegistrationRepository {}

late MockRegistrationEncryptionStrategy encryptionStrategyMock;
late MockRegistrationRepository registrationRepositoryMock;

final MobileAndCardRegistrationParameters parameters =
    MobileAndCardRegistrationParameters(
  notificationToken: 'notificationToken',
  mobileNumber: 'mobileNumber',
  cardNumber: 'cardNumber',
  expiryDate: 'expiryDate',
  cvv: 'cvv',
);
final String encryptionKey = 'encryptionKey';
final String encryptedParameters = 'encryptedParameters';
final RegistrationState state = RegistrationState(busy: true);
final registrationResponse = RegistrationResponse(
  user: User(id: 'userId'),
);

void main() {
  setUp(() {
    encryptionStrategyMock = MockRegistrationEncryptionStrategy();
    registrationRepositoryMock = MockRegistrationRepository();

    when(
      () => encryptionStrategyMock.encrypt(parameters),
    ).thenReturn(encryptedParameters);
    when(
      () => encryptionStrategyMock.encryptionKey,
    ).thenReturn(encryptionKey);
    when(() => registrationRepositoryMock.register(
          encryptedCredentials: encryptedParameters,
          encryptionKey: encryptionKey,
          notificationToken: parameters.notificationToken,
          deviceSession: null,
        )).thenAnswer(
      (_) async => registrationResponse,
    );
  });

  test('Should encrypted parameters and post them to the repository', () async {
    final step = FormRegistrationStep<MobileAndCardRegistrationParameters>(
      repository: registrationRepositoryMock,
      encryptionStrategy: encryptionStrategyMock,
    );

    await step(
      parameters: parameters,
      state: state,
    );

    verify(() => encryptionStrategyMock.encrypt(parameters)).called(1);
    verify(() => registrationRepositoryMock.register(
          encryptedCredentials: encryptedParameters,
          encryptionKey: encryptionKey,
          notificationToken: parameters.notificationToken,
        )).called(1);
  });

  test('Should return state with incremented step.', () async {
    final step = FormRegistrationStep<MobileAndCardRegistrationParameters>(
      repository: registrationRepositoryMock,
      encryptionStrategy: encryptionStrategyMock,
    );

    final result = await step(
      parameters: parameters,
      state: state,
    );

    expect(
        result,
        state.copyWith(
          currentStep: 1,
          currentParameters: registrationResponse,
        ));
  });
}
