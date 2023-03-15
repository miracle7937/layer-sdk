/// Error thrown when an object needs to perform an operation
/// for which a valid strategy was not provided.
class NoApplicableStrategyError extends Error {
  /// The value for which no strategy was applicable.
  final dynamic value;

  /// The strategies available for the object
  /// that tried to perform the operation.
  final List<dynamic> availableStrategies;

  /// Creates [NoApplicableStrategyError].
  NoApplicableStrategyError({
    this.value,
    required this.availableStrategies,
  });

  @override
  String toString() => 'No applicable strategy was found for value $value. '
      'Available strategies: $availableStrategies';
}
