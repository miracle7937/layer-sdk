import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain_layer/models.dart';
import '../../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// A Cubit that handles the state for the loyalty redemption.
class AlertsSettingsCubit extends Cubit<AlertsSettingsState> {
  final ChangeAlertPreferencesStatusUseCase
      _changeAlertPreferencesStatusUseCase;

  /// Creates a new [AlertsSettingsCubit].
  AlertsSettingsCubit({
    required ChangeAlertPreferencesStatusUseCase
        changeAlertPreferencesStatusUseCase,
    required User user,
  })  : _changeAlertPreferencesStatusUseCase =
            changeAlertPreferencesStatusUseCase,
        super(AlertsSettingsState(
          oldUser: user,
          newUser: user,
        ));

  /// Changing of settings event
  void onSettingsChanged(PrefAlerts settings) {
    emit(
      state.copyWith(
        newUser: state.newUser?.copyWith(
          prefAlerts: settings,
        ),
        events: state.addEvent(
          AlertsSettingsEvent.changeSettings,
        ),
      ),
    );
  }

  /// Do a loyalty points redemption
  Future<void> saveSettings() async {
    emit(
      state.copyWith(
        actions: state.addAction(
          AlertsSettingsAction.saveSettings,
        ),
        errors: state.removeErrorForAction(
          AlertsSettingsAction.saveSettings,
        ),
      ),
    );

    try {
      final userResult = await _changeAlertPreferencesStatusUseCase(
        prefAlerts: state.newUser!.prefAlerts!,
      );
      emit(
        state.copyWith(
          actions: state.removeAction(
            AlertsSettingsAction.saveSettings,
          ),
          newUser: userResult,
          events: state.addEvent(
            AlertsSettingsEvent.showResultView,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            AlertsSettingsAction.saveSettings,
          ),
          errors: state.addErrorFromException(
            action: AlertsSettingsAction.saveSettings,
            exception: e,
          ),
        ),
      );
    }
  }
}
