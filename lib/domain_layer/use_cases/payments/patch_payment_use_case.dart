import '../../abstract_repositories/payments/payments_repository_interface.dart';
import '../../models/payment/payment.dart';

/// Use case that submits and patches a payment.
class PatchPaymentUseCase {
  final PaymentsRepositoryInterface _repository;

  /// Creates a new [PatchPaymentUseCase] instance.
  const PatchPaymentUseCase({
    required PaymentsRepositoryInterface repository,
  }) : _repository = repository;

  /// Posts the provided payment
  Future<Payment> patch(
    Payment payment, {
    String? otp,
  }) {
    return _repository.patchBill(
      payment: payment,
    );
  }
}
