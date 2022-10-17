import '../../../data_layer/mappings.dart';
import '../../models.dart';

///The model used for patching the alert prefs
class AlertPreference extends UserPreference<List<ActivityType>> {
  ///Creates a new [AlertPreference]
  AlertPreference({
    required List<ActivityType> value,
  }) : super('alert', value);

  @override
  Map<String, dynamic> toJson() => {
        'alert': value
            .map(
              (activityType) => activityType.toJSONString,
            )
            .toList(),
      };

  @override
  List<Object?> get props => [
        value,
      ];
}
