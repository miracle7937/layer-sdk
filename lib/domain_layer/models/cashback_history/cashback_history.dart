import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../models.dart';

/// A model representing the cashback history.
class CashbackHistory extends Equatable {
  /// Offer transactions grouped by an offer id.
  final UnmodifiableMapView<int, UnmodifiableListView<OfferTransaction>>
      transactions;

  /// Total rewards grouped by an offer id.
  final UnmodifiableMapView<int, double> totalRewards;

  /// Creates [CashbackHistory].
  CashbackHistory({
    Map<int, List<OfferTransaction>>? transactions,
    Map<int, double>? totalRewards,
  })  : transactions = UnmodifiableMapView(transactions?.map(
              (key, value) => MapEntry(
                key,
                UnmodifiableListView(value),
              ),
            ) ??
            {}),
        totalRewards = UnmodifiableMapView(totalRewards ?? {});

  @override
  List<Object?> get props => [
        transactions,
        totalRewards,
      ];
}
