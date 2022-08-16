import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case for canceling Mandates
class CancelMandateUseCase {
  final MandateRepositoryInterface _repo;

  /// Creates a new [CancelMandateUseCase] instance
  CancelMandateUseCase({
    required MandateRepositoryInterface repository,
  }) : _repo = repository;

  /// Cancels the mandate of the provided id.
  ///
  /// Use the `otpValue` and `otpType` parameters to specify the OTP \
  /// configuration.
  Future<SecondFactorType?> call({
    required int mandateId,
    String? otpValue,
    SecondFactorType? otpType,
  }) {
    return _repo.cancelMandate(
      mandateId: mandateId,
      otpValue: otpValue,
      otpType: otpType,
    );
  }
}
