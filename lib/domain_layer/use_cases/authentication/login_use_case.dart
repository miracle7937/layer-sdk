import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case that verifies a user with the provided value,
/// username and password.
class LoginUseCase {
  final AuthenticationRepositoryInterface _repository;

  /// Creates a new [LoginUseCase] instance.
  LoginUseCase({
    required AuthenticationRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns the [User] belonging to `username` and `password`.
  Future<User?> call({
    required String username,
    required String password,
    String? notificationToken,
    String? deviceName,
    String? deviceModel,
  }) =>
      _repository.login(
        username: username,
        password: password,
        notificationToken: notificationToken,
        deviceName: deviceName,
        deviceModel: deviceModel,
      );
}
