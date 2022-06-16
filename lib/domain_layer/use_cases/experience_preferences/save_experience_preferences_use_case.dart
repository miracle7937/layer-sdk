import '../../abstract_repositories.dart';
import '../../models.dart';

/// An use case for saving the experience preferences.
class SaveExperiencePreferencesUseCase {
  final ExperiencePreferencesRepositoryInterface _repository;

  /// Creates a new [SaveExperiencePreferencesUseCase].
  SaveExperiencePreferencesUseCase({
    required ExperiencePreferencesRepositoryInterface repository,
  }) : _repository = repository;

  /// Saves the passed experience preferences.
  Future<List<ExperiencePreferences>> call({
    required String experienceId,
    required List<SaveExperiencePreferencesParameters> parameters,
  }) =>
      _repository.saveExperiencePreferences(
        experienceId: experienceId,
        parameters: parameters,
      );
}
