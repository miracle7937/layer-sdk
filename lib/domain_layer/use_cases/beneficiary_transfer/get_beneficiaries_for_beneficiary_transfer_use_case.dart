import '../../../features/beneficiaries.dart';

/// A use case that for the destination beneficiaries on the beneficiaries
/// transfer flow.
class GetDestinationBeneficiariesForBeneficiariesTransferUseCase {
  final BeneficiaryRepositoryInterface _beneficiaryRepository;

  /// Creates a new [GetDestinationBeneficiariesForBeneficiariesTransferUseCase]
  /// use case.
  const GetDestinationBeneficiariesForBeneficiariesTransferUseCase({
    required BeneficiaryRepositoryInterface beneficiaryRepository,
  }) : _beneficiaryRepository = beneficiaryRepository;

  /// Return the beneficiaries for the destination beneficiary picker
  /// on the beneficiary transfer flow.
  Future<List<Beneficiary>> call() => _beneficiaryRepository.list();
}
