import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../mappings/card/card_info_dto_mapping.dart';
import '../../providers.dart';

/// Handles all the cards data
class CardRepository implements CardRepositoryInterface {
  final CardProvider _provider;

  /// Creates a new [CardRepository] instance
  CardRepository(this._provider);

  /// Retrieves all the cards of the supplied customer
  Future<List<BankingCard>> listCustomerCards({
    String? customerId,
    bool includeDetails = true,
    bool forceRefresh = false,
  }) async {
    final cardDTOs = await _provider.listCustomerCards(
      customerId: customerId,
      includeDetails: includeDetails,
      forceRefresh: forceRefresh,
    );

    return cardDTOs.map((x) => x.toBankingCard()).toList(growable: false);
  }

  /// Returns all completed transactions of the supplied customer card
  Future<List<CardTransaction>> listCustomerCardTransactions({
    required String cardId,
    String? customerId,
    int limit = 50,
    int offset = 0,
    bool forceRefresh = false,
  }) async {
    final cardTransactionsDTOs = await _provider.listCustomerCardTransactions(
      cardId: cardId,
      customerId: customerId,
      limit: limit,
      offset: offset,
      forceRefresh: forceRefresh,
    );

    return cardTransactionsDTOs
        .map((x) => x.toCardTransaction())
        .toList(growable: false);
  }

  /// Returns the card info for the passed card id
  Future<CardInfo> getCardInfo({
    required int cardId,
    int? otpId,
    String? otpValue,
    SecondFactorType? secondFactorType,
    String? clientResponse,
    bool forceRefresh = false,
  }) async {
    final cardInfoDTO = await _provider.getCardInfo(
      cardId: cardId,
      otpId: otpId,
      otpValue: otpValue,
      secondFactorType: secondFactorType?.toSecondFactorTypeDTO(),
      clientResponse: clientResponse,
      forceRefresh: forceRefresh,
    );

    return cardInfoDTO.toCardInfo();
  }
}
