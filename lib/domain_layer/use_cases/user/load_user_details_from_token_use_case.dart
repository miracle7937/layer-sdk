import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case for loading the user details using a token.
class LoadUserDetailsFromTokenUseCase {
  final UserRepositoryInterface _repository;

  /// Creates a new [LoadUserDetailsFromTokenUseCase].
  const LoadUserDetailsFromTokenUseCase({
    required UserRepositoryInterface repository,
  }) : _repository = repository;

  /// Loads an user by its token.
  Future<User> call({
    required String token,
  }) =>
      _repository.getUserFromToken(token: token);
}
