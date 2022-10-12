import '../../../domain_layer/models/experience/experience_page.dart';

/// Extra container for the widget extra to cards
class ExtraCard {
  /// The if of the container
  final String id;

  /// If the container is visible
  final bool Function(ExperiencePage) visible;

  /// Widget position in the page
  final ExtraCardPosition position;

  /// Whether the provided widget is a Sliver or a Box widget
  final bool isSliver;

  /// Creates [ExtraCard]
  ExtraCard({
    required this.id,
    required this.visible,
    required this.position,
    this.isSliver = false,
  });
}

/// The extra container position where to placed on the page
enum ExtraCardPosition {
  /// To put the widget to top position
  top,

  /// To put the widget to bottom position
  bottom,
}
