import '../../../domain_layer/models.dart';

/// An abstract repository for the [ExperiencePreferences].
abstract class ExperiencePreferencesRepositoryInterface {
  /// Saves the user preferences related to the experience.
  Future<List<ExperiencePreferences>> saveExperiencePreferences({
    required String experienceId,
    required List<SaveExperiencePreferencesParameters> parameters,
  });
}
