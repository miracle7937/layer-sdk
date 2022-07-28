import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Handles all the beneficiaries data
class BeneficiaryRepository implements BeneficiaryRepositoryInterface {
  final BeneficiaryProvider _provider;

  /// Creates a new repository with the supplied [BeneficiaryProvider]
  BeneficiaryRepository(BeneficiaryProvider provider) : _provider = provider;

  /// Lists the beneficiaries.
  /// Of the provided `customerId`, if passed.
  /// Optionally filtering by searchText.
  ///
  /// Use [limit] and [offset] to paginate.
  @override
  Future<List<Beneficiary>> list({
    String? customerId,
    String? searchText,
    int limit = 50,
    int offset = 0,
    bool forceRefresh = false,
  }) async {
    final beneficiaryDTO = await _provider.list(
      customerID: customerId,
      searchText: searchText,
      limit: limit,
      offset: offset,
      forceRefresh: forceRefresh,
    );

    return beneficiaryDTO.map((e) => e.toBeneficiary()).toList(growable: false);
  }

  /// Add a new beneficiary.
  @override
  Future<Beneficiary> add({
    required Beneficiary beneficiary,
    bool forceRefresh = false,
  }) async {
    final beneficiaryDTO = await _provider.add(
      beneficiaryDTO: beneficiary.toBeneficiaryDTO(),
      forceRefresh: forceRefresh,
    );

    return beneficiaryDTO.toBeneficiary();
  }
}
