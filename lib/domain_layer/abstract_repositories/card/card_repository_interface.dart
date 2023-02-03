import '../../models.dart';

/// Abstract definition for the [CardRepository].
abstract class CardRepositoryInterface {
  /// Retrieves all the cards of the supplied customer
  Future<List<BankingCard>> listCustomerCards({
    String? customerId,
    bool includeDetails = true,
    bool forceRefresh = false,
  });
}
