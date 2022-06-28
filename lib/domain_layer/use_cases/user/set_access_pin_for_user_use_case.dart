import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case for setting an access pin for a user.
class SetAccessPinForUserUseCase {
  final UserRepositoryInterface _repository;

  /// Creates a new [SetAccessPinForUserUseCase].
  const SetAccessPinForUserUseCase({
    required UserRepositoryInterface repository,
  }) : _repository = repository;

  /// Sets passed the access pin to the user related to the passed token.
  Future<User> call({
    required String pin,
    required String token,
  }) =>
      _repository.setAccessPin(
        pin: pin,
        token: token,
      );
}
