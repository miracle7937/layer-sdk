import '../../abstract_repositories/card/card_repository_interface.dart';
import '../../models.dart';

/// Use case responsible of loading customer card transactions
class LoadCustomerCardInfoUseCase {
  final CardRepositoryInterface _repository;

  /// Creates a new [LoadCustomerCardInfoUseCase]
  LoadCustomerCardInfoUseCase({
    required CardRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns the card info for the passed card id
  Future<CardInfo> call({
    required int cardId,
    int? otpId,
    String? otpValue,
    SecondFactorType? secondFactorType,
    String? clientResponse,
    bool forceRefresh = false,
  }) =>
      _repository.getCardInfo(
        cardId: cardId,
        otpId: otpId,
        otpValue: otpValue,
        secondFactorType: secondFactorType,
        clientResponse: clientResponse,
        forceRefresh: forceRefresh,
      );
}
