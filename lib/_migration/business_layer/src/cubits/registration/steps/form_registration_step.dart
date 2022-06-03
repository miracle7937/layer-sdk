import '../../../../../../data_layer/network.dart';
import '../../../../../data_layer/data_layer.dart';
import '../../../cubits.dart';

/// A step that encapsulates the logic for encrypting
/// and posting the registration form data.
// TODO: think about the registration flows supported on the BE
// and refactor the registration cubit and steps.
class FormRegistrationStep<T extends RegistrationParameters>
    extends RegistrationStep<T> {
  /// A strategy to be used for sensitive data encryption.
  final RegistrationEncryptionStrategy<T> encryptionStrategy;

  /// The repository used to post registration form data.
  final RegistrationRepository repository;

  /// Creates [FormRegistrationStep].
  FormRegistrationStep({
    required this.repository,
    required this.encryptionStrategy,
  });

  @override
  Future<RegistrationState> call({
    required T parameters,
    required RegistrationState state,
  }) async {
    try {
      final deviceSession =
          (parameters as MobileAndCardRegistrationParameters).deviceSession;

      final encryptedCredentials = encryptionStrategy.encrypt(parameters);

      final registrationResponse = await repository.register(
        encryptedCredentials: encryptedCredentials,
        encryptionKey: encryptionStrategy.encryptionKey,
        notificationToken: parameters.notificationToken,
        deviceSession: deviceSession,
      );

      return state.copyWith(
        currentStep: state.currentStep + 1,
        // TODO: Consider how to return the 2FA info
        // without assuming that it will be the next step
        currentParameters: registrationResponse,
      );
    } on NetException catch (e) {
      return state.copyWith(
        stepError: RegistrationStateError.generic,
        stepErrorMessage: e.message,
      );
    }
  }
}
