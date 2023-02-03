import '../../dtos.dart';

///The model used for patching the alert prefs
class AlertPreferenceDTO extends UserPreferenceDTO<List<ActivityTypeDTO>> {
  ///Creates a new [AlertPreferenceDTO]
  AlertPreferenceDTO({
    required List<ActivityTypeDTO> value,
  }) : super('alert', value);

  @override
  Map<String, dynamic> toJson() => {
        'alert': value
            .map(
              (activityType) => activityType.value,
            )
            .toList(),
      };
}
