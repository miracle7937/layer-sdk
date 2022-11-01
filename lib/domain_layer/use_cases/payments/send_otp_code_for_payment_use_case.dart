import '../../../features/payments.dart';

/// A use case that sends the OTP code for a payment.
class SendOTPCodeForPaymentUseCase {
  final PaymentsRepositoryInterface _repository;

  /// Creates a new [SendOTPCodeForPaymentUseCase] use case.
  const SendOTPCodeForPaymentUseCase({
    required PaymentsRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns a payment resulting on sending the OTP code for the
  /// passed payment.
  Future<Payment> call({
    required Payment payment,
    required bool editMode,
  }) =>
      _repository.sendOTPCode(
        payment: payment,
        editMode: editMode,
      );
}
