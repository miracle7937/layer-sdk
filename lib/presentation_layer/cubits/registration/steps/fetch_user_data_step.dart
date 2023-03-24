import '../../../../../../data_layer/network.dart';
import '../../../../../../data_layer/repositories/user/user_repository.dart';
import '../../../../domain_layer/models.dart';
import '../../../cubits.dart';

/// A step for retrieving the full user data
/// This is used for the projects that does not implement a login
/// (the registration flow is the login itself)
class FetchUserDataStep<T> extends RegistrationStep<T> {
  /// The repository used to fetch the user data.
  final UserRepository repository;

  /// Creates [FetchUserDataStep].
  FetchUserDataStep({
    required this.repository,
  });

  @override
  Future<RegistrationState> call({
    required T parameters,
    required RegistrationState state,
  }) async {
    try {
      final user =
          await repository.getUserFromToken(token: parameters as String);

      final registrationResponse =
          state.currentParameters as RegistrationResponse;

      return state.copyWith(
        currentStep: state.currentStep + 1,
        currentParameters: registrationResponse.copyWith(
          user: user.copyWith(
            token: parameters,
            deviceId: registrationResponse.user.deviceId,
          ),
          ocraSecret: registrationResponse.ocraSecret,
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
