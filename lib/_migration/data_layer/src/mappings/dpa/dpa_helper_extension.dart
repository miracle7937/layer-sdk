import '../../../models.dart';

/// Helper extension for lists of [DPAVariable].
extension DPAVariableListExtension on List<DPAVariable> {
  /// Returns the list sorted by the order of the variables.
  List<DPAVariable> sortByOrder() {
    final result = <DPAVariable>[];

    result.addAll(this);

    result.sort(
      (a, b) {
        final orderA = a.order;
        final orderB = b.order;

        if (orderA == null && orderB == null) return 0;
        if (orderA == null) return 1;
        if (orderB == null) return -1;

        return orderA.compareTo(orderB);
      },
    );

    return result;
  }
}
