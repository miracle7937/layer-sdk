import '../../models.dart';

/// The abstract repository for the cashaback history.
// ignore: one_member_abstracts
abstract class CashbackHistoryRepositoryInterface {
  /// Returns the [CashbackHistory] for the provided parameters.
  Future<CashbackHistory> getCashbackHistory({
    DateTime? from,
    DateTime? to,
    int? offset,
    int? limit,
    bool forceRefresh = false,
  });
}
