import '../../../../data_layer/encryption.dart';
import '../../../../data_layer/network.dart';
import '../../../../data_layer/repositories.dart';
import '../../../cubits.dart';

/// A step that encapsulates the logic for encrypting
/// and posting the authentication form data.
// TODO: unit tests
class AuthenticationRegistrationStep<T extends RegistrationParameters>
    extends RegistrationStep<T> {
  /// A strategy to be used for sensitive data encryption.
  final RegistrationEncryptionStrategy<T> encryptionStrategy;

  /// The repository used to post registration form data.
  final RegistrationRepository repository;

  /// Creates [AuthenticationRegistrationStep].
  AuthenticationRegistrationStep({
    required this.repository,
    required this.encryptionStrategy,
  });

  @override
  Future<RegistrationState> call({
    required T parameters,
    required RegistrationState state,
  }) async {
    try {
      final encryptedCredentials = encryptionStrategy.encrypt(parameters);
      final customerId = await repository.authenticate(
        encryptedCredentials: encryptedCredentials,
        encryptionKey: encryptionStrategy.encryptionKey,
      );
      return state.copyWith(
        currentStep: state.currentStep + 1,
        currentParameters: FinalizeRegistrationParameters(
          customerId: customerId,
          encryptedCredentials: encryptedCredentials,
          encryptionKey: encryptionStrategy.encryptionKey,
        ),
      );
    } on NetException catch (e) {
      return state.copyWith(
        stepError: RegistrationStateError.generic,
        stepErrorMessage: e.message,
      );
    }
  }
}
