import '../../models.dart';
import '../../parameters.dart';
import '../../providers.dart';
import '../dtos.dart';
import '../mappings.dart';

/// A repository that can be used to fetched [Experience].
class ExperienceRepository {
  final ExperienceProvider _experienceProvider;
  final UserProvider _userProvider;

  /// Creates a new repository with the supplied [ExperienceProvider].
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
  Future<Experience> getExperience({
    required bool public,
    int? minPublicVersion,
  }) async {
    final experienceDTO = await _experienceProvider.getExperience(
      public: public,
      minPublicVersion: minPublicVersion,
    );
    final userDTO = public ? null : await _userProvider.getUser();
    _configureExperienceDTO(experienceDTO);
    return experienceDTO.toExperience(userDTO: userDTO);
  }

  /// Modifies the [ExperienceDTO] before mapping it to [Experience] model.
  ///
  /// Makes following modifications:
  /// - sorts pages by their [order],
  /// - sorts containers by their [order],
  /// - assigns values for container settings of type
  ///   [ExperienceSettingTypeDTO.image].
  void _configureExperienceDTO(ExperienceDTO dto) {
    dto.pages?.sort((p1, p2) => p1.order.compareTo(p2.order));
    dto.pages?.forEach(_sortPageContainers);
    dto.pages
        ?.where((page) => page.containers != null)
        .expand((page) => page.containers!)
        .forEach(_configureImageExperienceSettings);
  }

  /// Sorts containers by their [order].
  ///
  /// Containers without an order value will come first.
  void _sortPageContainers(ExperiencePageDTO pageDTO) {
    pageDTO.containers?.sort((a, b) {
      return a.order.compareTo(b.order);
    });
  }

  /// Configures the values of container settings of type
  /// [ExperienceSettingTypeDTO.image].
  void _configureImageExperienceSettings(
    ExperienceContainerDTO containerDTO,
  ) {
    if (containerDTO.settingDefinitions != null) {
      for (final definition in containerDTO.settingDefinitions!) {
        if (definition.type == ExperienceSettingTypeDTO.image &&
            definition.setting != null) {
          containerDTO.settingValues[definition.setting!] =
              '${_experienceProvider.netClient.netEndpoints.experienceImage}/'
              '${definition.setting}${containerDTO.containerId}.png';
        }
      }
    }
  }

  /// Saves the user preferences related to the experience.
  Future<List<ExperiencePreferences>> saveExperiencePreferences({
    required String experienceId,
    required List<SaveExperiencePreferencesParameters> parameters,
  }) async {
    final preferences = {
      for (var e in parameters)
        'container_setting.$experienceId.${e.containerId}.${e.key}': e.value
    };
    final dto = await _experienceProvider.saveExperiencePreferences(
      preferences: preferences,
    );
    return dto.experiencePreferences
            ?.map((e) => e.toExperiencePreferences())
            .toList(growable: false) ??
        [];
  }
}
