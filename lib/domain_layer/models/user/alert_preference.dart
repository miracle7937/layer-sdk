import '../../models.dart';

///The model used for patching the alert prefs
class AlertPreference extends UserPreference<List<ActivityType>> {
  ///Creates a new [AlertPreference]
  AlertPreference({
    required List<ActivityType> value,
  }) : super('alert', value);

  @override
  List<Object?> get props => [
        value,
      ];
}
