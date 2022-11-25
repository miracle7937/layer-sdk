import '../../abstract_repositories.dart';
import '../../models.dart';

/// A use case that sends the OTP code for retreiving a [CardInfo] from a card.
class SendOTPCodeForCardInfoUseCase {
  final CardInfoRepositoryInterface _repository;

  /// Creates a new [SendOTPCodeForCardInfoUseCase] use case.
  const SendOTPCodeForCardInfoUseCase({
    required CardInfoRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns a [CardInfo] resulting on sending the OTP code for the
  /// passed [cardId].
  Future<CardInfo> call({
    required String cardId,
  }) =>
      _repository.sendOTPCode(
        cardId: cardId,
      );
}
