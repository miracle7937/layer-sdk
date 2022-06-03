/// Extensions on [Map].
extension MapExtensions<R, K> on Map? {
  /// Looks for a value inside a [Map].
  ///
  /// Where [K] corresponds to the key of the [Map] and [R] correspond
  /// to the [runtimeType] for the value.
  ///
  /// If no coincidences occured, the [defaultValue] will be returned.
  R? lookup<R, K>(
    Iterable<K> keys, [
    R? defaultValue,
  ]) {
    if (this == null) return null;

    dynamic value = this;
    for (final key in keys) {
      if (value is Map<K, dynamic> && value.containsKey(key)) {
        value = value[key];
      } else {
        return defaultValue;
      }
    }

    return value as R;
  }
}
