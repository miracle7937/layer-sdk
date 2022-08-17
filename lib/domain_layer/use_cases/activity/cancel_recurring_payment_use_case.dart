import '../../../layer_sdk.dart';

/// Use case for canceling a payment
class CancelRecurringPaymentUseCase {
  final PaymentsRepositoryInterface _repository;

  /// Creates a new [CancelPaymentUseCase]
  CancelRecurringPaymentUseCase({
    required PaymentsRepositoryInterface repository,
  }) : _repository = repository;

  /// Cancels a recurring payment of the provided id.
  ///
  /// Use the `otpValue` parameter to specify the one password value.
  ///
  /// Use the `resendOTP` parameter to request a new OTP.
  Future<Payment> call({
    required String id,
    String? otpValue,
    bool resendOTP = false,
  }) =>
      _repository.deletePayment(
        id,
        otpValue: otpValue,
        resendOTP: resendOTP,
      );
}
