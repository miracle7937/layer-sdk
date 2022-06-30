import '../../abstract_repositories.dart';

/// An use case to patches the list of roles of an [User]
class PatchUserRolesUseCase {
  final UserRepositoryInterface _repository;

  /// Creates a new [PatchUserRolesUseCase] instance
  PatchUserRolesUseCase({
    required UserRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to patches the list of roles of a user
  ///
  /// Used only by the DBO app.
  Future<bool> call({
    required String userId,
    required List<String> roles,
  }) =>
      _repository.patchUserRoles(
        userId: userId,
        roles: roles,
      );
}
