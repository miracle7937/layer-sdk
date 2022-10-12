import '../../models.dart';

///The model used for patching the alert prefs
class AlertPreference extends UserPreference<PrefAlerts> {
  ///Creates a new [AlertPreference]
  AlertPreference({
    required PrefAlerts value,
  }) : super('alert', value);

  @override
  Map<String, dynamic> toJson() => {
        'alert': value,
      };

  @override
  List<Object?> get props => [
        value,
      ];
}
