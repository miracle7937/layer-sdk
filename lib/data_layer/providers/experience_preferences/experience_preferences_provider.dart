import '../../../../data_layer/network.dart';
import '../../dtos.dart';

/// A provider that handles API requests related to [ExperienceDTO].
class ExperiencePreferencesProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  /// Creates [ExperiencePreferencesProvider].
  ExperiencePreferencesProvider({
    required this.netClient,
  });

  /// Saves the user preferences related to the experience.
  ///
  /// The [preferences] parameter is a map representing the preferences values.
  /// The map keys should follow the following format:
  /// "container_setting.${experienceId}.${containerId}.${preferenceKey}".
  Future<UserDTO> saveExperiencePreferences({
    required String experienceId,
    required List<SaveExperiencePreferencesParametersDTO> parameters,
  }) async {
    final preferences = {
      for (var e in parameters)
        'container_setting.$experienceId.${e.containerId}.${e.key}': e.value
    };

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
