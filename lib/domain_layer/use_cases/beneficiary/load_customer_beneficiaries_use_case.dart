import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case responsible for loading beneficiaries
class LoadCustomerBeneficiariesUseCase {
  final BeneficiaryRepositoryInterface _beneficiaryRepository;

  /// Creates a new [LoadCustomerBeneficiariesUseCase] instance.
  const LoadCustomerBeneficiariesUseCase({
    required BeneficiaryRepositoryInterface beneficiaryRepository,
  }) : _beneficiaryRepository = beneficiaryRepository;

  /// Lists the beneficiaries.
  /// Of the provided `customerId`, if passed.
  /// Optionally filtering by searchText.
  ///
  /// Use [limit] and [offset] to paginate.
  Future<List<Beneficiary>> call({
    String? customerId,
    String? query,
    int offset = 0,
    int limit = 50,
    bool loadMore = false,
    bool forceRefresh = false,
    bool activeOnly = false,
  }) =>
      _beneficiaryRepository.list(
        customerId: customerId,
        limit: limit,
        offset: offset,
        forceRefresh: forceRefresh,
        searchText: query,
        activeOnly: activeOnly,
      );

  /// Getting of the beneficiary receipt.
  ///
  /// Returning list of bites that represents image if [isImage] is true
  /// or PDF if it's false.
  Future<List<int>> getReceipt(
    Beneficiary beneficiary, {
    bool isImage = true,
  }) async {
    return await _beneficiaryRepository.getReceipt(
      beneficiary,
      isImage: isImage,
    );
  }
}
