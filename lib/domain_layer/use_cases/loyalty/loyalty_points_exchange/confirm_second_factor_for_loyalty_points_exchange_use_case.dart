import '../../../abstract_repositories.dart';
import '../../../models.dart';

/// Use case for confirming the second factor on the loyalty points
/// exchange.
class ConfirmSecondFactorForLoyaltyPointsExchangeUseCase {
  final LoyaltyPointsExchangeRepositoryInterface _repository;

  /// Creates a new [ConfirmSecondFactorForLoyaltyPointsExchangeUseCase].
  const ConfirmSecondFactorForLoyaltyPointsExchangeUseCase({
    required LoyaltyPointsExchangeRepositoryInterface repository,
  }) : _repository = repository;

  /// Confirms the second factor that was returnes by the loyalty points
  /// exchange request. Returns the exchange mapped on a [LoyaltyPointsExchange]
  /// object.
  Future<LoyaltyPointsExchange> call({
    required String transactionId,
    String? pin,
    String? hardwareToken,
    String? otpId,
    String? otp,
  }) =>
      _repository.postSecondFactor(
        transactionId: transactionId,
        pin: pin,
        hardwareToken: hardwareToken,
        otpId: otpId,
        otp: otp,
      );
}
