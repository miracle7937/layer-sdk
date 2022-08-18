import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case that changes a user's password with the provided value,
/// newpassword.
///
/// This use case can only be used to change the user password and modify
/// other datas from [User].
///
/// If you want to completely reset the [User]'s password should
/// use [ResetPasswordUseCase]
class ChangePasswordUseCase {
  final AuthenticationRepositoryInterface _repository;

  /// Creates a new [ChangePasswordUseCase] instance.
  ChangePasswordUseCase({
    required AuthenticationRepositoryInterface repository,
  }) : _repository = repository;

  /// Changes the user's password belonging to `username`/`userId` and `oldPassword`
  /// with `newPassword` and its necessary to validate/confirm by `confirmPassword`
  ///
  /// It also can be used to change [User]'s data by `user` param
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
