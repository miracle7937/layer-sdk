import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case responsible for verifying beneficiary second factor
class VerifyBeneficiarySecondFactorUseCase {
  final BeneficiaryRepositoryInterface _beneficiaryRepository;

  /// Creates a new [VerifyBeneficiarySecondFactorUseCase] instance.
  const VerifyBeneficiarySecondFactorUseCase({
    required BeneficiaryRepositoryInterface beneficiaryRepository,
  }) : _beneficiaryRepository = beneficiaryRepository;

  /// Verify beneficiary add/edit with second factor.
  Future<Beneficiary> call({
    required Beneficiary beneficiary,
    required String value,
    required SecondFactorType secondFactorType,
    bool isEditing = false,
  }) =>
      _beneficiaryRepository.verifySecondFactor(
        beneficiary: beneficiary,
        value: value,
        secondFactorType: secondFactorType,
        isEditing: isEditing,
      );
}
