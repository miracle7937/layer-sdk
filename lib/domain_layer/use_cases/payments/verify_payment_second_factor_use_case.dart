import '../../abstract_repositories.dart';
import '../../models.dart';

/// A use case that verifies the second factor for a payment.
class VerifyPaymentSecondFactorUseCase {
  final PaymentsRepositoryInterface _repository;

  /// Creates a new [VerifyPaymentSecondFactorUseCase] use case.
  const VerifyPaymentSecondFactorUseCase({
    required PaymentsRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns a payment resulting on verifying the second factor for the
  /// passed payment.
  Future<Payment> call({
    required Payment payment,
    required String value,
    required SecondFactorType secondFactorType,
    required bool editMode,
  }) =>
      _repository.verifySecondFactor(
        payment: payment,
        value: value,
        secondFactorType: secondFactorType,
        editMode: editMode,
      );
}
