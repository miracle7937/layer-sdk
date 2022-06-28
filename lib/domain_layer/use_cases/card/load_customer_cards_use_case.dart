import '../../abstract_repositories/card/card_repository_interface.dart';
import '../../models/card/banking_card.dart';

/// Use case responsible for loading customer cards
class LoadCustomerCardsUseCase {
  final CardRepositoryInterface _repository;

  /// Creates a new [LoadCustomerCardsUseCase]
  LoadCustomerCardsUseCase({
    required CardRepositoryInterface repository,
  }) : _repository = repository;

  /// Retrieves all the cards of the supplied customer
  Future<List<BankingCard>> call({
    String? customerId,
    bool includeDetails = true,
    bool forceRefresh = false,
  }) =>
      _repository.listCustomerCards(
        customerId: customerId,
        includeDetails: includeDetails,
        forceRefresh: forceRefresh,
      );
}
