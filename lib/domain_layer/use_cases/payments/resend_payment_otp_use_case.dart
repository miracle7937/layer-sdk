import '../../abstract_repositories/payments/payments_repository_interface.dart';
import '../../models/payment/payment.dart';

/// Use case that submits a payment.
class ResendOTPPaymentUseCase {
  final PaymentsRepositoryInterface _repository;

  /// Creates a new [PostPaymentUseCase] instance.
  const ResendOTPPaymentUseCase({
    required PaymentsRepositoryInterface repository,
  }) : _repository = repository;

  /// Posts the provided payment
  Future<Payment> call(Payment payment) {
    return _repository.resendOTP(
      payment: payment,
    );
  }
}
