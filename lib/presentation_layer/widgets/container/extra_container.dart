/// Extra container for the widget extra to cards
class ExtraCard {
  /// The index of the page
  final int pageIndex;

  /// The if of the container
  final String id;

  /// If the container is visible
  final bool visible;

  /// Widget position in the page
  final ExtraCardPosition position;

  /// Creates [ExtraCard]
  ExtraCard({
    required this.pageIndex,
    required this.id,
    required this.visible,
    required this.position,
  });
}

/// The extra container position where to placed on the page
enum ExtraCardPosition {
  /// To put the widget to top position
  top,

  /// To put the widget to center position
  center,

  /// To put the widget to bottom position
  bottom,
}
