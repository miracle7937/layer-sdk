import '../../models.dart';
import '../../providers.dart';
import '../dtos.dart';
import '../mappings.dart';

/// Handles Loyalty points data
class LoyaltyPointsRepository {
  final LoyaltyPointsProvider _provider;

  ///  Creates a new repository with the supplied [LoyaltyPointsProvider]
  LoyaltyPointsRepository(LoyaltyPointsProvider provider)
      : _provider = provider;

  /// Fetches loyalty data and parses to [Loyalty] models
  Future<List<Loyalty>> listAllLoyalty() async {
    final loyaltyDTO = await _provider.fetchLoyalty();
    return loyaltyDTO.map((it) => it.toLoyalty()).toList(growable: false);
  }

  /// Fetches loyalty data and parses to [LoyaltyTransaction] models
  Future<List<LoyaltyTransaction>> listTransactions({
    LoyaltyTransactionType? transactionType,
    int? offset,
    int? limit,
    String? searchQuery,
    bool forceRefresh = false,
  }) async {
    final response = await _provider.fetchLoyaltyTransactions(
      transactionType: transactionType?.toLoyaltyTransactionTypeDTO() ??
          LoyaltyTransactionTypeDTO.none,
      offset: offset,
      limit: limit,
      searchQuery: searchQuery,
      forceRefresh: forceRefresh,
    );
    return response
        .map((it) => it.toLoyaltyTransaction())
        .toList(growable: false);
  }

  /// Fetches the exchange rate list
  Future<List<LoyaltyRate>> listRates({
    int? offset,
    int? limit,
    String? sortBy,
  }) async {
    final response = await _provider.fetchRates(
      offset: offset,
      limit: limit,
      sortBy: sortBy,
    );

    return response.map((it) => it.toRate()).toList(growable: false);
  }

  /// Fetches only the current burn rate
  Future<LoyaltyRate> getCurrentRate({
    bool forceRefesh = false,
  }) async {
    final response =
        await _provider.fetchCurrentRate(forceRefresh: forceRefesh);

    return response.toRate();
  }

  /// Fetches the amount of points to expire by the set date
  Future<LoyaltyExpiration> getExpiryPointsByDate({
    required DateTime expirationDate,
  }) async {
    final response =
        await _provider.fetchPointsByDate(expirationDate: expirationDate);

    return response.toLoyaltyExpiration();
  }

  /// Makes a burn/redeem of available points
  Future<LoyaltyExchange> postBurn({
    required int amount,
    String? accountId,
    String? cardId,
  }) async {
    final response = await _provider.postBurnPoints(
      amount: amount,
      accountId: accountId,
      cardId: cardId,
    );

    return response.toLoyaltyBurn();
  }

  /// Complement the burn/redeem but with uses second factor
  Future<LoyaltyExchange> postSecondFactor({
    required String transactionId,
    String? pin,
    String? hardwareToken,
    String? otpId,
    String? otp,
  }) async {
    final response = await _provider.postSecondFactor(
      transactionId: transactionId,
      pin: pin,
      hardwareToken: hardwareToken,
      otp: otp,
      otpId: otpId,
    );

    return response.toLoyaltyBurn();
  }
}
