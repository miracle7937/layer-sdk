import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case responsible for loading beneficiary's receipt.
class LoadBeneficiaryReceiptUseCase {
  final BeneficiaryRepositoryInterface _beneficiaryRepository;

  /// Creates a new [LoadBeneficiaryReceiptUseCase] instance.
  const LoadBeneficiaryReceiptUseCase({
    required BeneficiaryRepositoryInterface beneficiaryRepository,
  }) : _beneficiaryRepository = beneficiaryRepository;

  /// Requests a beneficiary receipt.
  ///
  /// Returning list of bytes that represents image if [isImage] is true
  /// or PDF if it's false.
  Future<List<int>> call({
    required Beneficiary beneficiary,
    bool isImage = true,
  }) {
    return _beneficiaryRepository.getReceipt(
      beneficiary,
      isImage: isImage,
    );
  }
}
