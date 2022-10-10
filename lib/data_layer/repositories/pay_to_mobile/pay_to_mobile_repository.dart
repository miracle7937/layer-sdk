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

  /// Resends the second factor for the passed pay to mobile ID.
  @override
  Future<PayToMobile> resendSecondFactor({
    required NewPayToMobile newPayToMobile,
  }) async {
    final payToMobileDTO = await _provider.resendSecondFactor(
      newPayToMobileDTO: newPayToMobile.toDTO(),
    );

    return payToMobileDTO.toPayToMobile();
  }
}
