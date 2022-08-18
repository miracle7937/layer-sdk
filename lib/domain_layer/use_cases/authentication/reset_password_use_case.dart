import '../../abstract_repositories.dart';

/// Use case that resets a user's password with the provided value,
/// newpassword.
///
/// This use case can only be used reset the [User]'s password to a new one
///
/// If you want to change the password and other [User]'s data you should
/// use [ChangePasswordUseCase]
class ResetPasswordUseCase {
  final AuthenticationRepositoryInterface _repository;

  /// Creates a new [ResetPasswordUseCase] instance.
  ResetPasswordUseCase({
    required AuthenticationRepositoryInterface repository,
  }) : _repository = repository;

  /// Resets the user's password belonging to `username` and `oldPassword`
  /// with `newPassword`.
  ///
  /// Returns `true` if successful.
  Future<bool> call({
    required String username,
    required String oldPassword,
    required String newPassword,
  }) =>
      _repository.resetPassword(
        username: username,
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
}
