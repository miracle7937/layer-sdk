import '../../../features/payments.dart';

/// A use case that sends the OTP code for a transfer ID.
class SendOTPCodeForPaymentUseCase {
  final PaymentsRepositoryInterface _repository;

  /// Creates a new [SendOTPCodeForPaymentUseCase] use case.
  const SendOTPCodeForPaymentUseCase({
    required PaymentsRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns a payment resulting on sending the OTP code for the
  /// passed payment id.
  Future<Payment> call({
    required int paymentId,
    required bool editMode,
  }) =>
      _repository.sendOTPCode(
        paymentId: paymentId,
        editMode: editMode,
      );
}
