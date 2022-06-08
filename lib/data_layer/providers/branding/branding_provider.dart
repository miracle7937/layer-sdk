import '../../dtos.dart';
import '../../network.dart';

/// A provider that handles API requests related to branding.
class BrandingProvider {
  /// The [NetClient] to use for the network requests.
  final NetClient netClient;

  /// Creates [BrandingProvider].
  BrandingProvider({
    required this.netClient,
  });

  /// Returns the branding file from the connected backend.
  Future<BrandingDTO> getBranding({
    bool forceRefresh = true,
  }) async {
    final response = await netClient.request(
      '${netClient.netEndpoints.file}/branding.json',
      forceRefresh: forceRefresh,
    );

    return BrandingDTO.fromJson(response.data);
  }

  /// Returns the logo from the given path.
  Future<String> getSVGLogo(
    String path, {
    bool forceRefresh = true,
  }) async {
    final response = await netClient.request(
      '${netClient.netEndpoints.images}$path',
      decodeResponse: false,
      forceRefresh: forceRefresh,
    );

    return response.data;
  }
}
