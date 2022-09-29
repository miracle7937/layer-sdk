import '../../abstract_repositories.dart';

/// Use case to patch the user's image
class PatchUserImageUseCase {
  final UserRepositoryInterface _repository;

  /// Creates a new [PatchUserImageUseCase]
  PatchUserImageUseCase({
    required UserRepositoryInterface repository,
  }) : _repository = repository;

  /// Uploads the newly selected image
  Future patchImage({required String base64}) =>
      _repository.patchImage(
        base64: base64,
      );
}
