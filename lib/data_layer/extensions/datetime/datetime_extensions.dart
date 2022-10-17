/// Helper extensions to [DateTime].
extension DateTimeExtensions on DateTime {
  /// Returns a new [DateTime] with the added grace period.
  DateTime addGracePeriod(int? gracePeriod) => add(
        Duration(days: gracePeriod ?? 0),
      );

  /// Returns the end of the given month.
  DateTime endOfTheMonth() => DateTime(year, month + 1, 0);
}
