import '../../abstract_repositories.dart';
import '../../models.dart';

/// An use case to request the password reset for an [User]
class RequestPasswordResetUseCase {
  final UserRepositoryInterface _repository;

  /// Creates a new [RequestPasswordResetUseCase] instance
  RequestPasswordResetUseCase({
    required UserRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method request the password reset for an user.
  ///
  /// Used exclusively by the console (DBO).
  ///
  /// This request then needs to be approved by another console user.
  Future<void> call({
    required String userId,
    required CustomerType customerType,
  }) =>
      _repository.requestPasswordReset(
        userId: userId,
        customerType: customerType,
      );
}
