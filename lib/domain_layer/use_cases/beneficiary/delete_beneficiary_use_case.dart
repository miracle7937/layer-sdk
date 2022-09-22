import '../../abstract_repositories.dart';

/// The use case responsible for deleting a beneficiary.
class DeleteBeneficiaryUseCase {
  final BeneficiaryRepositoryInterface _beneficiaryRepository;

  /// Creates new [DeleteBeneficiaryUseCase].
  DeleteBeneficiaryUseCase({
    required BeneficiaryRepositoryInterface beneficiaryRepository,
  }) : _beneficiaryRepository = beneficiaryRepository;

  /// Deletes the beneficiary with the provided id.
  Future<void> call({
    required int id,
  }) =>
      _beneficiaryRepository.delete(
        id: id,
      );
}
