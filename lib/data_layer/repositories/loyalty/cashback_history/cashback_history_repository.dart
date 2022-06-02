import '../../../../domain_layer/abstract_repositories.dart';
import '../../../../domain_layer/models.dart';

import '../../../dtos.dart';
import '../../../mappings.dart';
import '../../../providers.dart';

/// A repository that can be used to fetch the cashback history.
class CashbackHistoryRepository implements CashbackHistoryRepositoryInterface {
  final OfferTransactionProvider _provider;

  /// Creates [CashbackHistoryRepository].
  @override
  CashbackHistoryRepository({
    required OfferTransactionProvider provider,
  }) : _provider = provider;

  /// Returns the [CashbackHistory] for the provided parameters.
  @override
  Future<CashbackHistory> getCashbackHistory({
    DateTime? from,
    DateTime? to,
    int? offset,
    int? limit,
    bool forceRefresh = false,
  }) async {
    final dto = await _provider.getOfferTransactions(
      rewardType: RewardTypeDTO.cashback,
      from: from,
      to: to,
      offset: offset,
      limit: limit,
      forceRefresh: forceRefresh,
    );

    return dto.toCashbackHistory();
  }
}
