import '../../abstract_repositories.dart';
import '../../models.dart';

/// An use case to request the PIN reset for an [User]
class RequestPINResetUseCase {
  final UserRepositoryInterface _repository;

  /// Creates a new [RequestPINResetUseCase] instance
  RequestPINResetUseCase({
    required UserRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method request the PIN reset for an user.
  ///
  /// Used exclusively by the console (DBO).
  ///
  /// This request then needs to be approved by another console user.
  Future<void> call({
    required String userId,
    required CustomerType customerType,
  }) =>
      _repository.requestPINReset(
        userId: userId,
        customerType: customerType,
      );
}
