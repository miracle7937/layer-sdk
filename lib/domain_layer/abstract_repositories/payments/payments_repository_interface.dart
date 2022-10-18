import '../../models.dart';

/// Abstract definition of the repository that handles all the payments data.
abstract class PaymentsRepositoryInterface {
  /// Lists the payments of a customer using the provided `customerId`.
  ///
  /// Use the `limit` and `offset` params to paginate.
  Future<List<Payment>> list({
    required String customerId,
    int limit = 50,
    int offset = 0,
    bool forceRefresh = false,
    bool recurring = false,
  });

  /// Submits the provided payment
  Future<Payment> postPayment({
    required Payment payment,
    String? otp,
  });

  /// Patches the provided payment
  Future<Payment> patchPayment({
    required Payment payment,
    String? otp,
    bool resendOtp = false,
  });

  /// Sends the otp code for the passed payment id.
  Future<Payment> sendOTPCode({
    required int paymentId,
    required bool editMode,
  });

  /// Verifies the second factor for the passed payment id.
  Future<Payment> verifySecondFactor({
    required int paymentId,
    required String value,
    required SecondFactorType secondFactorType,
  });

  /// Resends the one time password to the customer
  Future<Payment> resendOTP({
    required Payment payment,
  });

  /// Deletes a payment
  Future<Payment> deletePayment(
    String id, {
    String? otpValue,
    bool resendOTP = false,
  });
}
