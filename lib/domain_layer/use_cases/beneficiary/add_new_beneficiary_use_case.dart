import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case responsible for adding a new beneficiary
class AddNewBeneficiaryUseCase {
  final BeneficiaryRepositoryInterface _beneficiaryRepository;

  /// Creates a new [AddNewBeneficiaryUseCase] instance.
  const AddNewBeneficiaryUseCase({
    required BeneficiaryRepositoryInterface beneficiaryRepository,
  }) : _beneficiaryRepository = beneficiaryRepository;

  /// Add a new beneficiary.
  Future<Beneficiary> call({
    required Beneficiary beneficiary,
    bool forceRefresh = false,
  }) =>
      _beneficiaryRepository.add(
        beneficiary: beneficiary,
        forceRefresh: forceRefresh,
      );
}
