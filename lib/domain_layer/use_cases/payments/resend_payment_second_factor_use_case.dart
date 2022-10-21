import '../../../features/payments.dart';

/// A use case that resends the second factor for a payment.
class ResendPaymentSecondFactorUseCase {
  final PaymentsRepositoryInterface _repository;

  /// Creates a new [ResendPaymentSecondFactorUseCase] use case.
  const ResendPaymentSecondFactorUseCase({
    required PaymentsRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns a payment resulting on resending the second factor for the
  /// passed payment.
  Future<Payment> call({
    required Payment payment,
    required bool editMode,
  }) =>
      _repository.resendSecondFactor(
        payment: payment,
        editMode: editMode,
      );
}
