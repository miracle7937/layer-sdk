import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Repository that handles the pay to mobile flow.
class PayToMobileRepository implements PayToMobileRepositoryInterface {
  final PayToMobileProvider _provider;

  /// Creates [PayToMobileRepository].
  PayToMobileRepository({
    required PayToMobileProvider provider,
  }) : _provider = provider;

  /// Submits a new pay to mobile flow and returns a pay to mobile element.
  @override
  Future<PayToMobile> submit({
    required NewPayToMobile newPayToMobile,
  }) async {
    final payToMobileDTO = await _provider.submit(
      newPayToMobileDTO: newPayToMobile.toDTO(),
    );

    return payToMobileDTO.toPayToMobile();
  }

  /// Sends the OTP code for the provided pay to mobile request ID.
  @override
  Future<PayToMobile> sendOTPCode({
    required String requestId,
  }) async {
    final payToMobileDTO = await _provider.sendOTPCode(
      requestId: requestId,
    );

    return payToMobileDTO.toPayToMobile();
  }

  /// Verifies the second factor for the passed pay to mobile request ID.
  @override
  Future<PayToMobile> verifySecondFactor({
    required String requestId,
    required String value,
    required SecondFactorType secondFactorType,
  }) async {
    final payToMobileDTO = await _provider.verifySecondFactor(
      requestId: requestId,
      value: value,
      secondFactorTypeDTO: secondFactorType.toSecondFactorTypeDTO(),
    );

    return payToMobileDTO.toPayToMobile();
  }

  /// Resends the second factor for the passed pay to mobile.
  @override
  Future<PayToMobile> resendSecondFactor({
    required PayToMobile payToMobile,
  }) async {
    final payToMobileDTO = await _provider.resendSecondFactor(
      payToMobileDTO: payToMobile.toPayToMobileDTO(),
    );

    return payToMobileDTO.toPayToMobile();
  }

  /// Deletes a pay to mobile using a request ID and returns the pay to mobile
  /// that was deleted.
  ///
  /// If the request succeded (no second factor was returned) `null` will be
  /// returned.
  @override
  Future<PayToMobile?> delete({
    required String requestId,
  }) async {
    final payToMobileDTO = await _provider.delete(
      requestId: requestId,
    );

    return payToMobileDTO == null ? null : payToMobileDTO.toPayToMobile();
  }

  /// Resends the withdrawal code from the passed pay to mobile request ID.
  @override
  Future<void> resendWithdrawalCode({
    required String requestId,
  }) =>
      _provider.resendWithdrawalCode(
        requestId: requestId,
      );

  /// Sends the OTP code for deleting the provided pay to mobile request ID.
  @override
  Future<PayToMobile> sendOTPCodeForDeleting({
    required String requestId,
  }) async {
    final payToMobileDTO = await _provider.sendOTPCodeForDeleting(
      requestId: requestId,
    );

    return payToMobileDTO.toPayToMobile();
  }

  /// Resends the second factor for deleting the passed pay to mobile
  /// request ID.
  @override
  Future<PayToMobile> resendSecondFactorForDeleting({
    required PayToMobile payToMobile,
  }) async {
    final payToMobileDTO = await _provider.resendSecondFactorForDeleting(
      payToMobileDTO: payToMobile.toPayToMobileDTO(),
    );

    return payToMobileDTO.toPayToMobile();
  }

  /// Verifies the second factor for the deleting passed pay to mobile
  /// request ID.
  @override
  Future<void> verifySecondFactorForDeleting({
    required String requestId,
    required String value,
    required SecondFactorType secondFactorType,
  }) =>
      _provider.verifySecondFactorForDeleting(
        requestId: requestId,
        value: value,
        secondFactorTypeDTO: secondFactorType.toSecondFactorTypeDTO(),
      );
}
