import 'dart:collection';

import 'package:equatable/equatable.dart';

import 'experience_setting.dart';

/// A model representing a card container configured in the Experience Studio.
class ExperienceContainer extends Equatable {
  /// Unique identifier of the container.
  final int id;

  /// Internal name of the container as defined in the experience sheet.
  final String name;

  /// Code of the container type as defined in the experience sheet.
  final String typeCode;

  /// Name of the container type as defined in the experience sheet.
  final String typeName;

  /// Title of the container.
  final String title;

  /// Default order in which the containers should be displayed.
  final int order;

  /// Settings included in this container.
  ///
  /// This list contains only settings with types defined
  /// in [ExperienceSettingType]. If the setting type you need is not defined
  /// there please add it to the type enum and implement required mapping.
  final UnmodifiableListView<ExperienceSetting> settings;

  /// Messages included in this container.
  final UnmodifiableMapView<String, String> messages;

  /// Creates [ExperienceContainer].
  ExperienceContainer({
    required this.id,
    required this.name,
    required this.typeCode,
    required this.typeName,
    required this.title,
    required this.order,
    required Iterable<ExperienceSetting> settings,
    required Map<String, String> messages,
  })  : settings = UnmodifiableListView(settings),
        messages = UnmodifiableMapView(messages);

  @override
  List<Object?> get props => [
        id,
        name,
        typeCode,
        typeName,
        title,
        order,
        settings,
      ];
}
