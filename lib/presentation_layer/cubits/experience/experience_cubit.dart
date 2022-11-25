import 'package:bloc/bloc.dart';

import '../../../data_layer/network.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// A cubit that manages the state of the [Experience]s.
class ExperienceCubit extends Cubit<ExperienceState> {
  final ConfigureUserExperienceWithPreferencesUseCase
      _configureUserExperienceByExperiencePreferencesUseCase;
  final GetExperienceAndConfigureItUseCase _getExperienceAndConfigureItUseCase;
  final SaveExperiencePreferencesUseCase _saveExperiencePreferencesUseCase;
  final LoadUserByCustomerIdUseCase _loadUserByCustomerIdUseCase;

  /// Creates the [ExperienceCubit].
  ExperienceCubit({
    required ConfigureUserExperienceWithPreferencesUseCase
        configureUserExperienceByExperiencePreferencesUseCase,
    required GetExperienceAndConfigureItUseCase
        getExperienceAndConfigureItUseCase,
    required SaveExperiencePreferencesUseCase saveExperiencePreferencesUseCase,
    required LoadUserByCustomerIdUseCase loadUserByCustomerIdUseCase,
  })  : _configureUserExperienceByExperiencePreferencesUseCase =
            configureUserExperienceByExperiencePreferencesUseCase,
        _getExperienceAndConfigureItUseCase =
            getExperienceAndConfigureItUseCase,
        _saveExperiencePreferencesUseCase = saveExperiencePreferencesUseCase,
        _loadUserByCustomerIdUseCase = loadUserByCustomerIdUseCase,
        super(ExperienceState());

  /// Updates the [Experience] object in the state
  @Deprecated('This method was introduces for core-banking compatibility. '
      'Only use it if you are trying to implement the layer sdk in a project '
      'that also depends on the core-banking package.')
  Future<void> update({
    required Experience experience,
    UserPermissions? userPermissions,
  }) async =>
      emit(
        state.copyWith(
          experience: experience,
          visiblePages: _configureUserExperienceByExperiencePreferencesUseCase(
            experience: experience,
            userPermissions: userPermissions,
          ),
        ),
      );

  /// Loads the [Experience] configured for the application
  /// in the Experience studio.
  ///
  /// The [public] parameter is used to determine whether
  /// a public (pre-login) or after-login experience should be fetched.
  ///
  /// The [minPublicVersion] optional parameter can be used to set
  /// a minimum version of the public experience to fetch.
  ///
  /// The [clearExperience] parameter is used for wheter if the previous
  /// experience in the state should be cleared before loading the
  /// new one or not.
  Future<void> load({
    required bool public,
    int? minPublicVersion,
    bool clearExperience = true,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        clearExperience: clearExperience,
        error: ExperienceStateError.none,
      ),
    );

    try {
      final experience = await _getExperienceAndConfigureItUseCase(
        public: public,
        minPublicVersion: minPublicVersion,
      );

      User? user;
      if (!public) {
        user = await _loadUserByCustomerIdUseCase();
      }

      emit(
        state.copyWith(
          experience: experience,
          visiblePages: _configureUserExperienceByExperiencePreferencesUseCase(
            experience: experience,
            userPermissions: user?.permissions,
          ),
          busy: false,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          error: e is NetException
              ? e.statusCode == null
                  ? ExperienceStateError.connectivity
                  : ExperienceStateError.network
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
      final user = await _loadUserByCustomerIdUseCase();

      emit(
        state.copyWith(
          busy: false,
          experience: experience,
          visiblePages: experience != null
              ? _configureUserExperienceByExperiencePreferencesUseCase(
                  experience: experience,
                  userPermissions: user.permissions,
                )
              : null,
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
