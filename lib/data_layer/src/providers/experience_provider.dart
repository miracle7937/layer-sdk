import '../../environment.dart';
import '../../network.dart';
import '../dtos.dart';

/// A provider that handles API requests related to [ExperienceDTO].
class ExperienceProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  /// Creates [ExperienceProvider].
  ExperienceProvider({
    required this.netClient,
  });

  /// Fetches the [ExperienceDTO] from the API.
  ///
  /// The [public] parameter is used to determine whether
  /// a public (pre-login) or after-login experience should be fetched.
  ///
  /// The [minPublicVersion] optional parameter can be used to set
  /// a minimum version of the public experience to fetch.
  /// If there is no experience meeting this criteria
  /// `public_experience_not_found` error will be returned.
  Future<ExperienceDTO> getExperience({
    required bool public,
    int? minPublicVersion,
  }) async {
    assert(EnvironmentConfiguration.current.experienceAppId != null);

    minPublicVersion ??= 1;

    final appId = EnvironmentConfiguration.current.experienceAppId;

    final response = await netClient.request(
      '${netClient.netEndpoints.experience}/$appId/$minPublicVersion',
      useDefaultToken: public,
      forceRefresh: true,
    );

    return ExperienceDTO.fromJson(response.data);
  }

  /// Saves the user preferences related to the experience.
  ///
  /// The [preferences] parameter is a map representing the preferences values.
  /// The map keys should follow the following format:
  /// "container_setting.${experienceId}.${containerId}.${preferenceKey}".
  Future<UserDTO> saveExperiencePreferences({
    required Map<String, dynamic> preferences,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.user,
      method: NetRequestMethods.patch,
      data: [
        {
          'pref': {'keys': preferences},
        },
      ],
      forceRefresh: true,
    );

    assert(response.data is List && response.data.length == 1);

    return UserDTO.fromJson(response.data.first);
  }
}
