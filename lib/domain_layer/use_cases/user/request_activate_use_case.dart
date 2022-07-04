import '../../abstract_repositories.dart';
import '../../models.dart';

/// An use case to request the activation of an [User]
class RequestActivateUseCase {
  final UserRepositoryInterface _repository;

  /// Creates a new [RequestActivateUseCase] instance
  RequestActivateUseCase({
    required UserRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to request the activation of an user.
  ///
  /// Used exclusively by the console (DBO).
  ///
  /// This request then needs to be approved by another console user.
  Future<void> call({
    required String userId,
    required CustomerType customerType,
  }) =>
      _repository.requestActivate(
        userId: userId,
        customerType: customerType,
      );
}
