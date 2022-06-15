import '../../../_migration/data_layer/repositories.dart';
import '../../models.dart';

/// Use case for getting the user details using a token.
class GetUserDetailsFromTokenUseCase {
  /// TODO: Replace this with the abstract repository when available.
  final UserRepository _repository;

  /// Creates a new [GetUserDetailsFromTokenUseCase].
  const GetUserDetailsFromTokenUseCase({
    required UserRepository repository,
  }) : _repository = repository;

  /// Gets an user by its token.
  Future<User> call({
    required String token,
  }) =>
      _repository.getUserFromToken(token: token);
}
