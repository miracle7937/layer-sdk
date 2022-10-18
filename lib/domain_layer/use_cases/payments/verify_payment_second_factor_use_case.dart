import '../../abstract_repositories.dart';
import '../../models.dart';

/// A use case that verifies the second factor for a payment id.
class VerifyPaymentSecondFactorUseCase {
  final PaymentsRepositoryInterface _repository;

  /// Creates a new [VerifyPaymentSecondFactorUseCase] use case.
  const VerifyPaymentSecondFactorUseCase({
    required PaymentsRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns a payment resulting on verifying the second factor for the
  /// passed payment id.
  Future<Payment> call({
    required int paymentId,
    required String value,
    required SecondFactorType secondFactorType,
  }) =>
      _repository.verifySecondFactor(
        paymentId: paymentId,
        value: value,
        secondFactorType: secondFactorType,
      );
}
