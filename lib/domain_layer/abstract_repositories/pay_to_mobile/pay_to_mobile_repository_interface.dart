import '../../models.dart';

/// Abstract repository for the pay to mobile flow.
abstract class PayToMobileRepositoryInterface {
  /// Submits a new pay to mobile and returns a pay to mobile element.
  Future<PayToMobile> submit({
    required NewPayToMobile newPayToMobile,
  });

  /// Sends the OTP code for the provided pay to mobile request ID.
  Future<PayToMobile> sendOTPCode({
    required String requestId,
  });

  /// Verifies the second factor for the passed pay to mobile request ID.
  Future<PayToMobile> verifySecondFactor({
    required String requestId,
    required String value,
    required SecondFactorType secondFactorType,
  });

  /// Resends the second factor for the passed pay to mobile.
  Future<PayToMobile> resendSecondFactor({
    required PayToMobile payToMobile,
  });

  /// Resends the withdrawal code from the passed pay to mobile request ID.
  Future<void> resendWithdrawalCode({
    required String requestId,
  });

  /// Deletes a pay to mobile using a request ID and returns the pay to mobile
  /// that was deleted.
  ///
  /// If the request succeded (no second factor was returned) `null` will be
  /// returned.
  Future<PayToMobile?> delete({
    required String requestId,
  });

  /// Sends the OTP code for deleting the provided pay to mobile request ID.
  Future<PayToMobile> sendOTPCodeForDeleting({
    required String requestId,
  });

  /// Resends the second factor for deleting the passed pay to mobile
  /// request ID.
  Future<PayToMobile> resendSecondFactorForDeleting({
    required PayToMobile payToMobile,
  });

  /// Verifies the second factor for the deleting passed pay to mobile
  /// request ID.
  Future<void> verifySecondFactorForDeleting({
    required String requestId,
    required String value,
    required SecondFactorType secondFactorType,
  });
}
