import '../../abstract_repositories/payments/payments_repository_interface.dart';
import '../../models/payment/payment.dart';

/// Use case that submits and patches a payment.
class PatchPaymentUseCase {
  final PaymentsRepositoryInterface _repository;

  /// Creates a new [PatchPaymentUseCase] instance.
  const PatchPaymentUseCase({
    required PaymentsRepositoryInterface repository,
  }) : _repository = repository;

  /// Patches the provided payment
  Future<Payment> patch(
    Payment payment, {
    String? otp,
    bool resendOtp = false,
  }) {
    return _repository.patchPayment(
      payment: payment,
      otp: otp,
      resendOtp: resendOtp,
    );
  }
}
