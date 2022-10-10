import '../../abstract_repositories.dart';
import '../../models.dart';

/// A use case that verifies the second factor for a pay to mobile request ID.
class SendOTPCodeForPayToMobileUseCase {
  final PayToMobileRepositoryInterface _repository;

  /// Creates a new [SendOTPCodeForPayToMobileUseCase] use case.
  const SendOTPCodeForPayToMobileUseCase({
    required PayToMobileRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns a [PayToMobile] resulting on sending the OTP code for the
  /// passed pay to mobile request ID.
  Future<PayToMobile> call({
    required String requestId,
  }) =>
      _repository.sendOTPCode(
        requestId: requestId,
      );
}
