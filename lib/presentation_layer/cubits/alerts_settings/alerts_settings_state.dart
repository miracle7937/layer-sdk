import 'package:collection/collection.dart';

import '../../../../domain_layer/models.dart';
import '../../cubits.dart';

/// The available busy actions that the cubit can perform.
enum AlertsSettingsAction {
  /// Saving of alerts preferences.
  saveSettings,
}

/// The available events that the cubit can emit.
enum AlertsSettingsEvent {
  /// Event for showing the result view.
  showResultView,
}

/// The state for the [AlertsSettingsCubit].
class AlertsSettingsState
    extends BaseState<AlertsSettingsAction, AlertsSettingsEvent, void> {
  /// Old user.
  final User? oldUser;

  /// New user.
  final User? newUser;

  /// If settings were changed.
  bool get settingsChanged => ListEquality().equals(
        oldUser?.enabledAlerts,
        newUser?.enabledAlerts,
      );

  /// Creates a new [AlertsSettingsState].
  AlertsSettingsState({
    super.actions = const <AlertsSettingsAction>{},
    super.errors = const <CubitError>{},
    super.events = const <AlertsSettingsEvent>{},
    this.oldUser,
    this.newUser,
  });

  @override
  AlertsSettingsState copyWith({
    Set<AlertsSettingsAction>? actions,
    Set<CubitError>? errors,
    Set<AlertsSettingsEvent>? events,
    User? oldUser,
    User? newUser,
  }) =>
      AlertsSettingsState(
        actions: actions ?? super.actions,
        errors: errors ?? super.errors,
        events: events ?? super.events,
        oldUser: oldUser ?? this.oldUser,
        newUser: newUser ?? this.newUser,
      );

  @override
  List<Object?> get props => [
        errors,
        actions,
        events,
        oldUser,
        newUser,
      ];
}
