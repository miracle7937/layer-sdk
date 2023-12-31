import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain_layer/models.dart';
import '../../../../domain_layer/use_cases.dart';
import '../../cubits.dart';
import '../../extensions.dart';

/// A Cubit that handles the state for the alerts settings.
class AlertsSettingsCubit extends Cubit<AlertsSettingsState> {
  final ChangeAlertsSettingsUseCase _changeAlertsSettingsUseCase;

  /// Creates a new [AlertsSettingsCubit].
  AlertsSettingsCubit({
    required ChangeAlertsSettingsUseCase changeAlertsSettingsUseCase,
    required User user,
  })  : _changeAlertsSettingsUseCase = changeAlertsSettingsUseCase,
        super(AlertsSettingsState(
          oldUser: user,
          newUser: user,
        ));

  /// Changing of settings event
  void onSettingsChanged(List<ActivityType> enabledAlerts) {
    emit(
      state.copyWith(
        newUser: state.newUser.copyWith(
          enabledAlerts: enabledAlerts,
        ),
      ),
    );
  }

  /// Saving alerts settings
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
      final userResult = await _changeAlertsSettingsUseCase(
        alertsTypes: state.newUser.enabledAlerts,
      );
      emit(
        state.copyWith(
          actions: state.removeAction(
            AlertsSettingsAction.saveSettings,
          ),
          newUser: state.newUser.copyWith(
            userPreferences: userResult.preferences,
          ),
          events: state.addEvent(
            AlertsSettingsEvent.showResultView,
          ),
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
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
