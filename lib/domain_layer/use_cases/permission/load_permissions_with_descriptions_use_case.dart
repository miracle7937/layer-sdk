import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case that loads all permission objects with its descriptions.
class LoadPermissionsUseCase {
  final PermissionRepositoryInterface _repository;

  /// Creates a new [LoadPermissionsUseCase] instance.
  LoadPermissionsUseCase({
    required PermissionRepositoryInterface repository,
  }) : _repository = repository;

  /// Loads all permission objects with its descriptions.
  Future<List<PermissionObject>> call() => _repository.listPermissions();
}
