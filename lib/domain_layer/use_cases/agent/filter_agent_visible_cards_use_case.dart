import 'package:collection/collection.dart';

import '../../models.dart';

/// Use Case that filters the list of [BankingCard]s a Agent can see.
class FilterAgentVisibleCardsUseCase {
  /// Creates a new [FilterAgentVisibleCardsUseCase] instance.
  const FilterAgentVisibleCardsUseCase();

  /// Use Case that filters the list of [BankingCard]s a Agent can see.
  List<BankingCard> call({
    required List<AgentACL> acls,
    required List<BankingCard> cards,
  }) =>
      acls
          .map((acl) => cards.firstWhereOrNull(
                (e) => e.cardId == acl.cardId,
              ))
          .whereNotNull()
          .toList();
}
