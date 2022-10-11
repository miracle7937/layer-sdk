import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case for loading the developer user details using
/// a `token` and `developerId`.
class LoadDeveloperUserDetailsFromTokenUseCase {
  final UserRepositoryInterface _repository;

  /// Creates a new [LoadDeveloperUserDetailsFromTokenUseCase].
  const LoadDeveloperUserDetailsFromTokenUseCase({
    required UserRepositoryInterface repository,
  }) : _repository = repository;

  /// Loads an user by its `token` and `developerId`.
  Future<User> call({
    required String token,
    required String developerId,
  }) =>
      _repository.getDeveloperUserFromToken(
        token: token,
        developerId: developerId,
      );
}
