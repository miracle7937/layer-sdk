/// Converter extension for the integers
extension IntConverter on int {
  /// Parses the number of milliseconds into a DateTime
  DateTime toDateTimeFromMilliseconds() =>
      DateTime.fromMillisecondsSinceEpoch(this);
}
