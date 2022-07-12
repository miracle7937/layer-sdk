import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case that verifies a access pin
class UpdateUserTokenUseCase {
  final AuthenticationRepositoryInterface _repository;

  /// Creates a new [UpdateUserTokenUseCase] instance.
  UpdateUserTokenUseCase({
    required AuthenticationRepositoryInterface repository,
  }) : _repository = repository;

  /// Verifies access pin with the `pin` value.
  ///
  /// Returns [VerifyPinResponse] depends on verify process status.
  Future<void> call({String? token}) =>
      _repository.updateUserToken(updateToken: token);
}
