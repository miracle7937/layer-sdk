import '../../../layer_sdk.dart';

/// Use case for canceling a payment
class CancelRecurringPaymentUseCase {
  final PaymentsRepositoryInterface _repo;

  /// Creates a new [CancelPaymentUseCase]
  CancelRecurringPaymentUseCase({
    required PaymentsRepositoryInterface paymentsRepository,
  }) : _repo = paymentsRepository;

  /// Callable method to cancel a payment
  Future<Payment> call(
    String id, {
    String? otpValue,
    bool resendOTP = false,
  }) async {
    return _repo.deletePayment(
      id,
      otpValue: otpValue,
      resendOTP: resendOTP,
    );
  }
}
