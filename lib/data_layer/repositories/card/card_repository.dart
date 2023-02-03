import 'package:flutter/foundation.dart';

import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Handles all the cards data
class CardRepository implements CardRepositoryInterface {
  /// The provider used for network requests.
  @protected
  final CardProvider provider;

  /// Creates a new [CardRepository] instance
  CardRepository(this.provider);

  /// Retrieves all the cards of the supplied customer
  Future<List<BankingCard>> listCustomerCards({
    String? customerId,
    bool includeDetails = true,
    bool forceRefresh = false,
  }) async {
    final cardDTOs = await provider.listCustomerCards(
      customerId: customerId,
      includeDetails: includeDetails,
      forceRefresh: forceRefresh,
    );

    return cardDTOs.map((x) => x.toBankingCard()).toList(growable: false);
  }
}
