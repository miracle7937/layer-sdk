import '../../models.dart';

/// The [Profile] repository interface definition.
abstract class ProfileRepositoryInterface {
  /// Fetches the [Profile] for the provided [customerID]
  Future<Profile> getProfile({
    required String customerID,
    bool forceRefresh = false,
  });
}
