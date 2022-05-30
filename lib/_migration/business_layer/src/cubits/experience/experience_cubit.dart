import 'package:bloc/bloc.dart';
import '../../../../data_layer/data_layer.dart';

import 'experience_state.dart';
import 'use_cases/configure_user_experience.dart';

/// A cubit that manages the state of the [Experience]s.
class ExperienceCubit extends Cubit<ExperienceState> {
  final ExperienceRepository _repository;
  final ConfigureUserExperience _configureUserExperience;

  /// Creates the [ExperienceCubit].
  ExperienceCubit({
    required ExperienceRepository repository,
    required ConfigureUserExperience configureUserExperience,
  })  : _repository = repository,
        _configureUserExperience = configureUserExperience,
        super(ExperienceState());

  /// Updates the [Experience] object in the state
  Future<void> update({
    required Experience experience,
  }) async {
    emit(
      ExperienceState(
        experience: experience,
        visiblePages: _configureUserExperience(experience: experience),
      ),
    );
  }

  /// Loads the [Experience] configured for the application
  /// in the Experience studio.
  ///
  /// The [public] parameter is used to determine whether
  /// a public (pre-login) or after-login experience should be fetched.
  ///
  /// The [minPublicVersion] optional parameter can be used to set
  /// a minimum version of the public experience to fetch.
  Future<void> load({
    required bool public,
    int? minPublicVersion,
  }) async {
    emit(state.copyWith(busy: true));

    final experience = await _repository.getExperience(
      public: public,
      minPublicVersion: minPublicVersion,
    );

    // TODO: error handling
    emit(
      ExperienceState(
        experience: experience,
        visiblePages: _configureUserExperience(experience: experience),
        busy: false,
      ),
    );
  }

  /// Saves the updated experience preferences.
  Future<void> updatePreferences({
    required String experienceId,
    required List<SaveExperiencePreferencesParameters> parameters,
  }) async {
    emit(
      state.copyWith(busy: true),
    );

    final preferences = await _repository.saveExperiencePreferences(
      experienceId: experienceId,
      parameters: parameters,
    );

    final experience = state.experience?.copyWith(preferences: preferences);

    // TODO: error handling

    emit(
      state.copyWith(
        experience: experience,
        visiblePages: experience != null
            ? _configureUserExperience(
                experience: experience,
              )
            : null,
        busy: false,
      ),
    );
  }
}
