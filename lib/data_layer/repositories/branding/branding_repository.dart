import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Handles the branding data.
class BrandingRepository implements BrandingRepositoryInterface {
  final BrandingProvider _provider;

  /// Creates a new repository with the supplied [BrandingProvider]
  BrandingRepository(
    BrandingProvider provider,
  ) : _provider = provider;

  /// Returns a [Branding] with the logo from the connected backend.
  ///
  /// If [forceDefault] is true, returns the default [LayerBranding] instead
  /// of fetching from the server. Defaults to `false`.
  Future<Branding> getBranding({
    bool forceDefault = false,
    bool forceRefresh = true,
  }) async {
    final dto = forceDefault
        ? null
        : await _provider.getBranding(
            forceRefresh: forceRefresh,
          );

    final branding = forceDefault ? LayerBranding() : dto!.toBranding();

    if (branding.logoURL?.isEmpty ?? true) return branding;

    final logo = await _provider.getSVGLogo(
      branding.logoURL!,
      forceRefresh: forceRefresh,
    );

    return branding.copyWith(
      logo: logo,
    );
  }
}
