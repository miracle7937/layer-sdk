import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings/profile/profile_dto_mapping.dart';
import '../../providers.dart';

/// Repository that handles all the [Profile] data.
class ProfileRepository implements ProfileRepositoryInterface {
  final ProfileProvider _profileProvider;

  /// Creates a new [ProfileRepository] instance.
  ProfileRepository({
    required ProfileProvider profileProvider,
  }) : _profileProvider = profileProvider;

  @override
  Future<Profile> getProfile({
    required String customerID,
    bool forceRefresh = false,
  }) async {
    final profileDTO = await _profileProvider.getProfile(
      customerID: customerID,
      forceRefresh: forceRefresh,
    );

    return profileDTO.toProfile();
  }
}
