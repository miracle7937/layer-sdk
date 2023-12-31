import '../../models.dart';

/// Abstract definition of the repository that handles all the payments data.
abstract class PaymentsRepositoryInterface {
  /// Submits the provided payment
  Future<Payment> postPayment({
    required Payment payment,
  });

  /// Patches the provided payment
  Future<Payment> patchPayment({
    required Payment payment,
  });

  /// Sends the otp code for the passed payment.
  Future<Payment> sendOTPCode({
    required Payment payment,
    required bool editMode,
  });

  /// Verifies the second factor for the passed payment.
  Future<Payment> verifySecondFactor({
    required Payment payment,
    required String value,
    required SecondFactorType secondFactorType,
    required bool editMode,
  });

  /// Resends second factor for the passed payment.
  Future<Payment> resendSecondFactor({
    required Payment payment,
    required bool editMode,
  });

  /// Deletes a payment
  Future<Payment> deletePayment(
    String id, {
    String? otpValue,
    bool resendOTP = false,
  });
}
