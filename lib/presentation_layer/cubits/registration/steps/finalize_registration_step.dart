import '../../../../../../data_layer/network.dart';
import '../../../../data_layer/encryption.dart';
import '../../../../data_layer/repositories.dart';
import '../../../cubits.dart';

/// A step that encapsulates the logic for encrypting
/// and posting the registration form data.
// TODO: unit tests
class FinalizeRegistrationStep
    extends RegistrationStep<FinalizeRegistrationParameters> {
  /// The repository used to post registration form data.
  final RegistrationRepository repository;

  /// Creates [FormRegistrationStep].
  FinalizeRegistrationStep({
    required this.repository,
  });

  @override
  Future<RegistrationState> call({
    required FinalizeRegistrationParameters parameters,
    required RegistrationState state,
  }) async {
    try {
      final registrationResponse = await repository.finalize(
        encryptedCredentials: parameters.encryptedCredentials,
        encryptionKey: parameters.encryptionKey,
        deviceSession: parameters.deviceSession,
        notificationToken: parameters.notificationToken,
        customerId: parameters.customerId,
        otp: parameters.otp,
      );
      return state.copyWith(
        currentStep: state.currentStep + 1,
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
