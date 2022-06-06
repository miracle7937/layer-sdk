import '../../../abstract_repositories.dart';
import '../../../models.dart';

/// Use case that loads the cashback history.
class LoadCashbackHistoryUseCase {
  final CashbackHistoryRepositoryInterface _repository;

  /// Creates a new [LoadCashbackHistoryUseCase] use case.
  LoadCashbackHistoryUseCase({
    required CashbackHistoryRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns cashback history.
  ///
  /// Use the [from] and [to] values to retrieve the cashback history for
  /// a specific date range.
  Future<CashbackHistory> call({
    DateTime? from,
    DateTime? to,
    bool forceRefresh = false,
  }) =>
      _repository.getCashbackHistory(
        from: from,
        to: to,
        forceRefresh: forceRefresh,
      );
}
