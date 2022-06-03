import '../../../domain_layer/models.dart';

/// Extensions for the [CashbackHistory] model.
extension CashbackHistoryExtension on CashbackHistory? {
  /// The sum of all rewards in the [CashbackHistory].
  double get totalRewards => (this?.totalRewards.values.isEmpty ?? true)
      ? 0.0
      : this!.totalRewards.values.reduce(
            (r1, r2) => r1 + r2,
          );
}
