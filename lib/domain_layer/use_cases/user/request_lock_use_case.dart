import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case to request the lock of an [User]
class RequestLockUseCase {
  final UserRepositoryInterface _repository;

  /// Creates a new [RequestLockUseCase] instance
  RequestLockUseCase({
    required UserRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to request the lock of an user.
  ///
  /// Used exclusively by the console (DBO).
  ///
  /// This request then needs to be approved by another console user.
  Future<void> call({
    required String userId,
    required CustomerType customerType,
  }) =>
      _repository.requestLock(
        userId: userId,
        customerType: customerType,
      );
}
