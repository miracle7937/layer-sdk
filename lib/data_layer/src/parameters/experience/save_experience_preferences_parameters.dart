import 'package:equatable/equatable.dart';

/// Parameters used for saving the [ExperiencePreferences].
class SaveExperiencePreferencesParameters extends Equatable {
  /// Identifier of the [ExperienceContainer] that the preferences relate to.
  final String containerId;

  /// Preference key.
  final String key;

  /// Preference value.
  final String value;

  /// Creates [SaveExperiencePreferencesParameters].
  SaveExperiencePreferencesParameters({
    required this.containerId,
    required this.key,
    required this.value,
  });

  @override
  List<Object?> get props => [
        containerId,
        key,
        value,
      ];
}
