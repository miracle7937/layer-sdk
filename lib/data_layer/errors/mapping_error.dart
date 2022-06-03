/// Exception thrown when mapping an object into another fails.
class MappingException implements Exception {
  /// What we were trying to map.
  final Type from;

  /// Into what we were trying to map.
  final Type to;

  /// The value that was used on the conversion.
  ///
  /// Optional. Make sure the toString of this type is implemented, or
  /// else the message won't be helpful.
  final dynamic value;

  /// An optional details text to append to the end of the message.
  final String? details;

  /// Creates a new [MappingException] with the mapping types and optionally
  /// some details string to be added to the end of the message.
  MappingException({
    required this.from,
    required this.to,
    this.value,
    this.details,
  });

  String toString() =>
      'Cannot convert ${value != null ? 'value "$value" from ' : ''}'
      '$from to $to'
      '${details != null ? ': $details' : ''}';
}
