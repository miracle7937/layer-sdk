import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case that verifies a access pin
class VerifyAccessPinUseCase {
  final AuthenticationRepositoryInterface _repository;

  /// Creates a new [VerifyAccessPinUseCase] instance.
  VerifyAccessPinUseCase({
    required AuthenticationRepositoryInterface repository,
  }) : _repository = repository;

  /// Verifies access pin with the `pin` value.
  ///
  /// Returns [VerifyPinResponse] depends on verify process status.
  Future<VerifyPinResponse> call({required String pin}) =>
      _repository.verifyAccessPin(pin: pin);
}
