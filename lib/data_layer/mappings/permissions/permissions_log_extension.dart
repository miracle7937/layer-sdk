/// Helper extension to log a `bool`
extension BooleanLogExtension on bool {
  /// Transforms into a cleaned string with an optional tag.
  /// Only returns if value is true to keep log cleaner.
  String toLog([String? tag]) =>
      !this ? '' : '${(tag?.isNotEmpty ?? false) ? '$tag: ' : ''}$this';
}

/// Helper extension to log a list of `String`
extension StringListLogExtension on List<String> {
  /// Joins non-empty strings
  String logJoin() => where((e) => e.isNotEmpty).join(', ');
}
