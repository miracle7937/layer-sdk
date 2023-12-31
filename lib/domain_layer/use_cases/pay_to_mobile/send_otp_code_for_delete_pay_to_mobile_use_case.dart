import '../../abstract_repositories.dart';
import '../../models.dart';

/// A use case that sends the OTP code for deleting a pay to mobile transaction.
class SendOTPCodeForDeletePayToMobileUseCase {
  final PayToMobileRepositoryInterface _repository;

  /// Creates a new [SendOTPCodeForDeletePayToMobileUseCase] use case.
  const SendOTPCodeForDeletePayToMobileUseCase({
    required PayToMobileRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns a [PayToMobile] resulting on sending the OTP code for the
  /// passed pay to mobile request ID.
  Future<PayToMobile> call({
    required String requestId,
  }) =>
      _repository.sendOTPCodeForDeleting(
        requestId: requestId,
      );
}
