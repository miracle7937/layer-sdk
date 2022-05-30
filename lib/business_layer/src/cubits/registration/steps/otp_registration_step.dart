import '../../../../../data_layer/data_layer.dart';
import '../../../cubits.dart';

/// A step that encapsulates the logic for verifying the OTP.
class OTPRegistrationStep extends RegistrationStep<RegistrationResponse> {
  /// The repository used to post registration data.
  final SecondFactorRepository repository;

  /// Creates [OTPRegistrationStep].
  OTPRegistrationStep({
    required this.repository,
  });

  @override
  Future<RegistrationState> call({
    required RegistrationResponse parameters,
    required RegistrationState state,
  }) async {
    try {
      if (parameters.secondFactorVerification == null ||
          parameters.user.token == null) {
        throw ArgumentError(
          'Second factor verification details and user token '
          'are required to verify the OTP',
        );
      }
      await repository.verifyCustomerSecondFactor(
        secondFactor: parameters.secondFactorVerification!,
        token: parameters.user.token!,
      );
      return state.copyWith(currentStep: state.currentStep + 1);
    } on NetException catch (e) {
      return state.copyWith(
        stepError: RegistrationStateError.generic,
        stepErrorMessage: e.message,
      );
    }
  }
}
