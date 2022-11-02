import '../../../domain_layer/models.dart';
import '../../cubits.dart';

/// The available busy actions that the cubit can perform.
enum PushNotificationAlertsActions {
  /// Loading the alert
  loadingAlert,
}

/// The state for the [PushNotificationAlertsState].
class PushNotificationAlertsState
    extends BaseState<PushNotificationAlertsActions, void, void> {
  /// The result alert
  final Activity? alert;

  /// Creates a new [PushNotificationAlertsState]
  PushNotificationAlertsState({
    this.alert,
    super.actions = const <PushNotificationAlertsActions>{},
    super.errors = const <CubitError>{},
  });

  @override
  PushNotificationAlertsState copyWith({
    Activity? alert,
    Set<PushNotificationAlertsActions>? actions,
    Set<CubitError>? errors,
  }) {
    return PushNotificationAlertsState(
      alert: alert ?? this.alert,
      actions: actions ?? this.actions,
      errors: errors ?? this.errors,
    );
  }

  @override
  List<Object?> get props => [alert, actions, errors];
}
