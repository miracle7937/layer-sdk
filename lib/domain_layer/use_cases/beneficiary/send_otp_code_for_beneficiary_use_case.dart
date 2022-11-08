import '../../abstract_repositories.dart';
import '../../models.dart';

/// A use case that sends the OTP code for a beneficiary.
class SendOTPCodeForBeneficiaryUseCase {
  final BeneficiaryRepositoryInterface _repository;

  /// Creates a new [SendOTPCodeForBeneficiaryUseCase] use case.
  const SendOTPCodeForBeneficiaryUseCase({
    required BeneficiaryRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns a beneficiary resulting on sending the OTP code for the
  /// passed beneficiary.
  Future<Beneficiary> call({
    required Beneficiary beneficiary,
    required bool isEditing,
  }) =>
      _repository.sendOTPCode(
        beneficiary: beneficiary,
        isEditing: isEditing,
      );
}
