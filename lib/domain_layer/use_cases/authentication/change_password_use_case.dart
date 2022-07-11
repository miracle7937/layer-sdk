import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case that changes a user's password with the provided value,
/// newpassword.
class ChangePasswordUseCase {
  final AuthenticationRepositoryInterface _repository;

  /// Creates a new [ChangePasswordUseCase] instance.
  ChangePasswordUseCase({
    required AuthenticationRepositoryInterface repository,
  }) : _repository = repository;

  /// Resets the user's password belonging to `username` and `oldPassword`
  /// with `newPassword`.
  ///
  /// Returns [MessageResponse] if successful or not.
  Future<MessageResponse> call({
    int? userId,
    String? username,
    User? user,
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) =>
      _repository.changePassword(
        userId: userId,
        username: username,
        user: user,
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
}
