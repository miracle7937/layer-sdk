import '../../models.dart';

/// Abstract repository that handles the branding data.
// ignore: one_member_abstracts
abstract class BrandingRepositoryInterface {
  /// Returns a [Branding] with the logo from the connected backend.
  ///
  /// If [forceDefault] is true, returns the default [LayerBranding] instead
  /// of fetching from the server. Defaults to `false`.
  Future<Branding> getBranding({
    bool forceDefault = false,
    bool forceRefresh = true,
  });
}
