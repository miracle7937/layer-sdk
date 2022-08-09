import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case responsible for resending beneficiary second factor
class ResendBeneficiarySecondFactorUseCase {
  final BeneficiaryRepositoryInterface _beneficiaryRepository;

  /// Creates a new [ResendBeneficiarySecondFactorUseCase] instance.
  const ResendBeneficiarySecondFactorUseCase({
    required BeneficiaryRepositoryInterface beneficiaryRepository,
  }) : _beneficiaryRepository = beneficiaryRepository;

  /// Resend second factor for beneficiary add/edit.
  Future<Beneficiary> call({
    required Beneficiary beneficiary,
    bool isEditing = false,
  }) =>
      _beneficiaryRepository.resendSecondFactor(
        beneficiary: beneficiary,
        isEditing: isEditing,
      );
}
