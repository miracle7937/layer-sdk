import '../../../_migration/data_layer/repositories.dart';
import '../../models.dart';

/// Use case for loading the user details using a token.
class LoadUserDetailsFromTokenUseCase {
  /// TODO: Replace this with the abstract repository when available.
  final UserRepository _repository;

  /// Creates a new [LoadUserDetailsFromTokenUseCase].
  const LoadUserDetailsFromTokenUseCase({
    required UserRepository repository,
  }) : _repository = repository;

  /// Loads an user by its token.
  Future<User> call({
    required String token,
  }) =>
      _repository.getUserFromToken(token: token);
}
