import '../../../layer_sdk.dart';
import '../../mappings.dart';

/// A repository for the [ExperiencePreferences].
class ExperiencePreferencesRepository
    implements ExperiencePreferencesRepositoryInterface {
  final ExperiencePreferencesProvider _experienceProvider;

  /// Creates a new repository with
  /// the supplied [ExperiencePreferencesProvider].
  ExperiencePreferencesRepository({
    required ExperiencePreferencesProvider experienceProvider,
  }) : _experienceProvider = experienceProvider;

  /// Saves the user preferences related to the experience.
  @override
  Future<List<ExperiencePreferences>> saveExperiencePreferences({
    required String experienceId,
    required List<SaveExperiencePreferencesParameters> parameters,
  }) async {
    final dto = await _experienceProvider.saveExperiencePreferences(
      experienceId: experienceId,
      parameters: parameters
          .map((e) => e.toSaveExperiencePreferencesParametersDTO())
          .toList(),
    );

    return dto.experiencePreferences
            ?.map((e) => e.toExperiencePreferences())
            .toList(growable: false) ??
        [];
  }
}
