/// Common list operations.
extension ListUtils<E> on List<E> {
  /// Returns a list copy sorted by the supplied [compare] function.
  List<E> sortedCopy([int Function(E, E)? compare]) {
    return [...this]..sort(compare);
  }
}
