import 'package:collection/collection.dart';

import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../mappings.dart';

/// An extension that provides mapping for [OfferTransactionResponseDTO].
extension OfferTransactionResponseDTOMapping on OfferTransactionResponseDTO {
  /// Returns [CashbackHistory] created from this [OfferTransactionResponseDTO].
  CashbackHistory toCashbackHistory() {
    final groups = offerGroups?.where((element) => element.offerId != null);
    return CashbackHistory(
      transactions: groupBy<OfferTransactionDTO, int>(
        transactions?.where((transaction) => transaction.offerId != null) ?? [],
        (transaction) => transaction.offerId!,
      ).map(
        (key, value) => MapEntry(
          key,
          value.map((e) => e.toOfferTransaction()).toList(),
        ),
      ),
      totalRewards: Map.fromIterables(
        groups?.map((e) => e.offerId!) ?? [],
        groups?.map((e) => e.totalRewardAmount ?? 0) ?? [],
      ),
    );
  }
}
