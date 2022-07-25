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
  ///
  /// Use the [customerId] parameter for loading the beneficiaries related
  /// to that customer.
  ///
  /// The [searchText] field can be used for filtering the beneficiaries.
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
}
