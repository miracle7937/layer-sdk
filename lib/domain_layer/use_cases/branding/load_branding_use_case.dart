import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case that loads branding information.
class LoadBrandingUseCase {
  final BrandingRepositoryInterface _repository;

  /// Creates a new [LoadBrandingUseCase] instance.
  LoadBrandingUseCase({
    required BrandingRepositoryInterface repository,
  }) : _repository = repository;

  /// Retrieves the branding information.
  Future<Branding> call({
    bool forceDefault = false,
    bool forceRefresh = true,
  }) =>
      _repository.getBranding(
        forceDefault: forceDefault,
        forceRefresh: forceRefresh,
      );
}
