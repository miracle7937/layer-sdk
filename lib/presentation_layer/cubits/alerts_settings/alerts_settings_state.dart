import '../../../../domain_layer/models.dart';
import '../../cubits.dart';

/// The available busy actions that the cubit can perform.
enum AlertsSettingsAction {
  /// Saving of alerts preferences.
  saveSettings,
}

/// The available events that the cubit can emit.
enum AlertsSettingsEvent {
  /// Event for changing settings.
  changeSettings,

  /// Event for showing the result view.
  showResultView,
}

/// The state for the [AlertsSettingsCubit].
class AlertsSettingsState
    extends BaseState<AlertsSettingsAction, AlertsSettingsEvent, void> {
  /// Base currency code.
  final User? oldUser;

  /// Base currency code.
  final User? newUser;

  /// Exchange result.
  final LoyaltyPointsExchange? exchangeResult;

  /// Creates a new [AlertsSettingsState].
  AlertsSettingsState({
    super.actions = const <AlertsSettingsAction>{},
    super.errors = const <CubitError>{},
    super.events = const <AlertsSettingsEvent>{},
    this.oldUser,
    this.newUser,
    this.exchangeResult,
  });

  @override
  AlertsSettingsState copyWith({
    Set<AlertsSettingsAction>? actions,
    Set<CubitError>? errors,
    Set<AlertsSettingsEvent>? events,
    LoyaltyPointsExchange? exchangeResult,
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
        exchangeResult,
        oldUser,
        newUser,
      ];
}
