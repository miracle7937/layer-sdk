import '../../../errors.dart';
import '../../../models.dart';
import '../../dtos.dart';

/// Extension that provides mapping from [ExperiencePreferencesDTOMapping]
/// to [ExperiencePreferences].
extension ExperiencePreferencesDTOMapping on ExperiencePreferencesDTO {
  /// Returns an [ExperiencePreferences] built
  /// from this [ExperiencePreferencesDTOMapping].
  ExperiencePreferences toExperiencePreferences() {
    if (experienceId == null) {
      throw MappingException(
        from: ExperiencePreferencesDTO,
        to: ExperiencePreferences,
        value: this,
        details: '`experienceId cannot be null',
      );
    }
    return ExperiencePreferences(
      experienceId: experienceId!,
      containerPreferences: containerPreferences?.map(
            (e) => e.toExperienceContainerPreferences(),
          ) ??
          [],
    );
  }
}

/// Extension that provides mapping from [ExperienceContainerPreferencesDTO]
/// to [ExperienceContainerPreferences].
extension ExperienceContainerPreferencesDTOMapping
    on ExperienceContainerPreferencesDTO {
  /// Returns an [ExperienceContainerPreferences] built
  /// from this [ExperienceContainerPreferencesDTO].
  ExperienceContainerPreferences toExperienceContainerPreferences() {
    if (containerId == null) {
      throw MappingException(
        from: ExperienceContainerPreferencesDTO,
        to: ExperienceContainerPreferences,
        value: this,
        details: '`containerId cannot be null',
      );
    }
    return ExperienceContainerPreferences(
      containerId: containerId!,
      preferences: preferences ?? {},
    );
  }
}
