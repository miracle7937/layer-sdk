import '../../../abstract_repositories.dart';
import '../../../models.dart';

/// Use case for exchanging loyalty points.
class ExchangeLoyaltyPointsUseCase {
  final LoyaltyPointsExchangeRepositoryInterface _repository;

  /// Creates a new [ExchangeLoyaltyPointsUseCase].
  const ExchangeLoyaltyPointsUseCase({
    required LoyaltyPointsExchangeRepositoryInterface repository,
  }) : _repository = repository;

  /// Exchanges the passed amount of loyalty points and returns the result
  /// mapped as a [LoyaltyPointsExchange] object.
  Future<LoyaltyPointsExchange> call({
    required int amount,
    String? accountId,
    String? cardId,
  }) =>
      _repository.postBurn(
        amount: amount,
        accountId: accountId,
        cardId: cardId,
      );
}
