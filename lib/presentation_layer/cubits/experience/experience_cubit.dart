import 'package:bloc/bloc.dart';

import '../../../data_layer/network.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import 'experience_state.dart';

/// A cubit that manages the state of the [Experience]s.
class ExperienceCubit extends Cubit<ExperienceState> {
  final ConfigureUserExperienceByExperiencePreferencesUseCase
      _configureUserExperienceByExperiencePreferencesUseCase;
  final GetExperienceAndConfigureItUseCase _getExperienceAndConfigureItUseCase;
  final SaveExperiencePreferencesUseCase _saveExperiencePreferencesUseCase;

  /// Creates the [ExperienceCubit].
  ExperienceCubit({
    required ConfigureUserExperienceByExperiencePreferencesUseCase
        configureUserExperienceByExperiencePreferencesUseCase,
    required GetExperienceAndConfigureItUseCase
        getExperienceAndConfigureItUseCase,
    required SaveExperiencePreferencesUseCase saveExperiencePreferencesUseCase,
  })  : _configureUserExperienceByExperiencePreferencesUseCase =
            configureUserExperienceByExperiencePreferencesUseCase,
        _getExperienceAndConfigureItUseCase =
            getExperienceAndConfigureItUseCase,
        _saveExperiencePreferencesUseCase = saveExperiencePreferencesUseCase,
        super(ExperienceState());

  /// Updates the [Experience] object in the state
  Future<void> update({
    required Experience experience,
  }) async {
    emit(
      ExperienceState(
        experience: experience,
        visiblePages: _configureUserExperienceByExperiencePreferencesUseCase(
          experience: experience,
        ),
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
    emit(
      state.copyWith(
        busy: true,
        error: ExperienceStateError.none,
      ),
    );

    try {
      final experience = await _getExperienceAndConfigureItUseCase(
        public: public,
        minPublicVersion: minPublicVersion,
      );

      emit(
        ExperienceState(
          experience: experience,
          visiblePages: _configureUserExperienceByExperiencePreferencesUseCase(
            experience: experience,
          ),
          busy: false,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          error: e is NetException
              ? ExperienceStateError.network
              : ExperienceStateError.generic,
          errorMessage: e is NetException ? e.message : null,
        ),
      );
    }
  }

  /// Saves the updated experience preferences.
  Future<void> updatePreferences({
    required String experienceId,
    required List<SaveExperiencePreferencesParameters> parameters,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        error: ExperienceStateError.none,
      ),
    );

    try {
      final preferences = await _saveExperiencePreferencesUseCase(
        experienceId: experienceId,
        parameters: parameters,
      );

      final experience = state.experience?.copyWith(preferences: preferences);

      emit(
        state.copyWith(
          experience: experience,
          visiblePages: experience != null
              ? _configureUserExperienceByExperiencePreferencesUseCase(
                  experience: experience,
                )
              : null,
          busy: false,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          error: e is NetException
              ? ExperienceStateError.network
              : ExperienceStateError.generic,
          errorMessage: e is NetException ? e.message : null,
        ),
      );
    }
  }
}
