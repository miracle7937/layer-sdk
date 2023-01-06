import '../../dtos.dart';
import '../../network.dart';

/// A provider that handles API requests related to [ProfileDTO].
class ProfileProvider {
  /// The [NetClient] to use for the network requests.
  final NetClient netClient;

  /// Creates [ProfileProvider].
  ProfileProvider({
    required this.netClient,
  });

  /// Returns customer's profile by [customerID].
  ///
  /// Throws an exception if the profile is not found.
  Future<ProfileDTO> getProfile({
    required String customerID,
    bool forceRefresh = true,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.profile,
      forceRefresh: forceRefresh,
      queryParameters: {
        'customer_id': customerID,
      },
      throwAllErrors: false,
    );

    if (response.data is Map && response.data.length > 0) {
      return ProfileDTO.fromJson(response.data);
    }

    throw Exception('Profile not found');
  }
}
