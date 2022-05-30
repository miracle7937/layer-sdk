import 'dart:collection';

import 'package:equatable/equatable.dart';

import 'experience_container.dart';

/// A model representing a page configured in the Experience Studio.
class ExperiencePage extends Equatable {
  /// Page title
  final String? title;

  /// Icon to be displayed in the navigation menu.
  final String? icon;

  /// Order in which this page appears in the navigation menu.
  final int order;

  /// Experience containers associated with this page.
  final UnmodifiableListView<ExperienceContainer> containers;

  /// Creates [ExperiencePage].
  ExperiencePage({
    this.title,
    this.icon,
    required this.order,
    required Iterable<ExperienceContainer> containers,
  }) : containers = UnmodifiableListView(containers);

  /// Creates a new instance of [ExperiencePage] based on this one.
  ExperiencePage copyWith({
    String? title,
    String? icon,
    int? order,
    Iterable<ExperienceContainer>? containers,
  }) {
    return ExperiencePage(
      title: title ?? this.title,
      icon: icon ?? this.icon,
      order: order ?? this.order,
      containers: containers ?? this.containers,
    );
  }

  @override
  List<Object?> get props => [
        title,
        icon,
        order,
        containers,
      ];
}
