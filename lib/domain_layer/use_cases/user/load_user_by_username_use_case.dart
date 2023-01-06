import '../../abstract_repositories.dart';
import '../../models.dart';

/// An use case to load the [User]
class LoadUserByUsernameUseCase {
  final UserRepositoryInterface _repository;

  /// Creates a new [LoadUserByUsernameUseCase] instance
  LoadUserByUsernameUseCase({
    required UserRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to load the [User] by `username`
  Future<User> call(
    String username,
  ) =>
      _repository.getUser(
        username: username,
      );
}
