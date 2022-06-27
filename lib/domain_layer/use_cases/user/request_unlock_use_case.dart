import '../../abstract_repositories.dart';
import '../../models.dart';

/// An use case to request the unlocking of an [User]
class RequestUnlockUseCase {
  final UserRepositoryInterface _repository;

  /// Creates a new [RequestUnlockUseCase] instance
  RequestUnlockUseCase({
    required UserRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method request the unlocking of an user.
  ///
  /// Used exclusively by the console (DBO).
  ///
  /// This request then needs to be approved by another console user.
  Future<void> call({
    required String userId,
    required CustomerType customerType,
  }) =>
      _repository.requestUnlock(
        userId: userId,
        customerType: customerType,
      );
}
