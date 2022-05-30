import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

/// A representation of user preferences related to the [Experience].
class ExperiencePreferences extends Equatable {
  /// Identifier of the [Experience] that the preferences relate to.
  final String experienceId;

  /// A list of preferences for specific containers.
  final UnmodifiableListView<ExperienceContainerPreferences>
      containerPreferences;

  /// Creates [ExperiencePreferences].
  ExperiencePreferences({
    required this.experienceId,
    required Iterable<ExperienceContainerPreferences> containerPreferences,
  }) : containerPreferences = UnmodifiableListView(containerPreferences);

  /// Returns the preferences map for a specific containerId.
  ///
  /// Returns null if preferences are not found.
  UnmodifiableMapView<String, dynamic>? forContainerId(String containerId) =>
      containerPreferences
          .firstWhereOrNull(
            (element) => element.containerId == containerId,
          )
          ?.preferences;

  @override
  List<Object?> get props => [
        experienceId,
        containerPreferences,
      ];
}

/// A representation of user preferences related to the [ExperienceContainer].
class ExperienceContainerPreferences extends Equatable {
  /// A key used in the [preferences] map to hold a value
  /// for container order preferred by the user.
  static const String orderKey = 'pref_order';

  /// A key used in the [preferences] map to hold a value
  /// for container visibility preferred by the user.
  static const String visibilityKey = 'pref_visibility';

  /// Identifier of the [ExperienceContainer] that the preferences relate to.
  final String containerId;

  /// A map containing the values of user preferences for a specific container.
  final UnmodifiableMapView<String, dynamic> preferences;

  /// Creates [ExperienceContainerPreferences].
  ExperienceContainerPreferences({
    required this.containerId,
    required Map<String, dynamic> preferences,
  }) : preferences = UnmodifiableMapView(preferences);

  @override
  List<Object?> get props => [
        containerId,
        preferences,
      ];
}
