import 'package:equatable/equatable.dart';

/// The available values for the theme brightness.
enum SettingThemeBrightness {
  /// Use the system brightness
  auto,

  /// Light theme
  light,

  /// Dark theme
  dark,
}

/// Holds the general application settings
class ApplicationSettings extends Equatable {
  /// The theme brightness.
  final SettingThemeBrightness brightness;

  /// Creates a new settings object
  const ApplicationSettings({
    this.brightness = SettingThemeBrightness.auto,
  });

  @override
  List<Object> get props => [
        brightness,
      ];

  /// Creates a new state based on this one.
  ApplicationSettings copyWith({
    SettingThemeBrightness? brightness,
  }) =>
      ApplicationSettings(
        brightness: brightness ?? this.brightness,
      );
}
