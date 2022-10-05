import '../../models.dart';

/// Abstract definition for the [CardRepository].
abstract class CardRepositoryInterface {
  /// Retrieves all the cards of the supplied customer
  Future<List<BankingCard>> listCustomerCards({
    String? customerId,
    bool includeDetails = true,
    bool forceRefresh = false,
  });

  /// Returns all completed transactions of the supplied customer card
  Future<List<CardTransaction>> listCustomerCardTransactions({
    required String cardId,
    String? customerId,
    int limit = 50,
    int offset = 0,
    bool forceRefresh = false,
  });

  /// Returns the card info for the passed card id
  Future<CardInfo> getCardInfo({
    required int cardId,
    int? otpId,
    String? otpValue,
    SecondFactorType? secondFactorType,
    String? clientResponse,
    bool forceRefresh = false,
  });
}
