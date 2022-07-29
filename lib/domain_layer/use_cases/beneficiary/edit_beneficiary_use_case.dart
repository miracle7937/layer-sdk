import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case responsible for adding a new beneficiary
class EditBeneficiaryUseCase {
  final BeneficiaryRepositoryInterface _beneficiaryRepository;

  /// Creates a new [EditBeneficiaryUseCase] instance.
  const EditBeneficiaryUseCase({
    required BeneficiaryRepositoryInterface beneficiaryRepository,
  }) : _beneficiaryRepository = beneficiaryRepository;

  /// Add a new beneficiary.
  Future<Beneficiary> call({
    required Beneficiary beneficiary,
    bool forceRefresh = false,
  }) =>
      _beneficiaryRepository.edit(
        beneficiary: beneficiary,
        forceRefresh: forceRefresh,
      );
}
