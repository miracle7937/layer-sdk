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

  /// Resends the second factor for the passed pay to mobile ID.
  Future<PayToMobile> resendSecondFactor({
    required NewPayToMobile newPayToMobile,
  });
}
