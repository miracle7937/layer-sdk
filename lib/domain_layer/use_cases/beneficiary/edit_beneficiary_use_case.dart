import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case responsible for editing a beneficiary
class EditBeneficiaryUseCase {
  final BeneficiaryRepositoryInterface _beneficiaryRepository;

  /// Creates a new [EditBeneficiaryUseCase] instance.
  const EditBeneficiaryUseCase({
    required BeneficiaryRepositoryInterface beneficiaryRepository,
  }) : _beneficiaryRepository = beneficiaryRepository;

  /// Edits an existing beneficiary.
  Future<Beneficiary> call({
    required Beneficiary beneficiary,
    bool forceRefresh = false,
  }) =>
      _beneficiaryRepository.edit(
        beneficiary: beneficiary,
        forceRefresh: forceRefresh,
      );
}
