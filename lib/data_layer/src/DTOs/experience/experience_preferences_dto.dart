/// Data transfer object representing user preferences
/// related to a specific experience.
class ExperiencePreferencesDTO {
  /// Identifier of the experience that the preferences relate to.
  String? experienceId;

  /// A list of preferences for specific containers.
  List<ExperienceContainerPreferencesDTO>? containerPreferences;

  /// Creates [ExperiencePreferencesDTO] from json.
  ExperiencePreferencesDTO.fromJson({
    this.experienceId,
    required Map<String, dynamic> json,
  }) : containerPreferences = json.entries
            .map(
              (entry) => ExperienceContainerPreferencesDTO(
                containerId: entry.key,
                preferences: entry.value,
              ),
            )
            .toList();
}

/// Data transfer object representing user preferences
/// related to a specific container.
class ExperienceContainerPreferencesDTO {
  /// Identifier of the container that the preferences relate to.
  String? containerId;

  /// A map containing the values of user preferences for a specific container.
  Map<String, dynamic>? preferences;

  /// Creates [ExperienceContainerPreferencesDTO].
  ExperienceContainerPreferencesDTO({
    this.containerId,
    this.preferences,
  });
}
