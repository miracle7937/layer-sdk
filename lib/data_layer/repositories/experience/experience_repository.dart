import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// A repository for the [Experience].
class ExperienceRepository implements ExperienceRepositoryInterface {
  final ExperienceProvider _experienceProvider;
  final UserProvider _userProvider;

  /// Creates a new repository with the supplied [ExperienceProvider] and
  /// [UserProvider].
  ExperienceRepository({
    required ExperienceProvider experienceProvider,
    required UserProvider userProvider,
  })  : _experienceProvider = experienceProvider,
        _userProvider = userProvider;

  /// Fetches [Experience] configured for the application
  /// in the Experience studio.
  ///
  /// The [public] parameter is used to determine whether
  /// a public (pre-login) or after-login experience should be fetched.
  ///
  /// The [minPublicVersion] optional parameter can be used to set
  /// a minimum version of the public experience to fetch.
  /// If there is no experience meeting this criteria
  /// `public_experience_not_found` error will be returned.
  @override
  Future<Experience> getExperience({
    required bool public,
    int? minPublicVersion,
  }) async {
    final experienceDTO = await _experienceProvider.getExperience(
      public: public,
      minPublicVersion: minPublicVersion,
    );
    final userDTO = public ? null : await _userProvider.getUser();

    return experienceDTO.toExperience(
      userDTO: userDTO,
      experienceImageURL:
          _experienceProvider.netClient.netEndpoints.experienceImage,
    );
  }
}
