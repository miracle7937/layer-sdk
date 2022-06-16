/// Data transfer object representing an objet
/// related to saving an experience preference.
class SaveExperiencePreferencesParametersDTO {
  /// Identifier of the experience container that the preferences relate to.
  String? containerId;

  /// Preference key.
  String? key;

  /// Preference value.
  String? value;

  /// Creates a new [SaveExperiencePreferencesParametersDTO].
  SaveExperiencePreferencesParametersDTO({
    this.containerId,
    this.key,
    this.value,
  });
}
