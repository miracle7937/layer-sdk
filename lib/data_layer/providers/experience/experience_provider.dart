import '../../../../data_layer/network.dart';
import '../../dtos.dart';
import '../../environment.dart';

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
}
