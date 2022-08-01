import '../../abstract_repositories/payments/payments_repository_interface.dart';
import '../../models/payment/payment.dart';

/// Use case that submits a payment.
class PostPaymentUseCase {
  final PaymentsRepositoryInterface _repository;

  /// Creates a new [PostPaymentUseCase] instance.
  const PostPaymentUseCase({
    required PaymentsRepositoryInterface repository,
  }) : _repository = repository;

  /// Posts the provided payment
  Future<Payment> pay(Payment payment) {
    return _repository.payBill(payment: payment);
  }
}
