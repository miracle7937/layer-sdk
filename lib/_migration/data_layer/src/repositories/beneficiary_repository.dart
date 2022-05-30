import '../../models.dart';
import '../../providers.dart';
import '../mappings.dart';

/// Handles all the beneficiaries data
class BeneficiaryRepository {
  final BeneficiaryProvider _provider;

  /// Creates a new repository with the supplied [BeneficiaryProvider]
  BeneficiaryRepository(BeneficiaryProvider provider) : _provider = provider;

  /// Lists the beneficiaries, optionally filtering by searchText
  ///
  /// Use [limit] and [offset] to paginate
  Future<List<Beneficiary>> list({
    required String customerID,
    String? searchText,
    int limit = 50,
    int offset = 0,
    bool forceRefresh = false,
  }) async {
    final beneficiaryDTO = await _provider.list(
      customerID: customerID,
      searchText: searchText,
      limit: limit,
      offset: offset,
      forceRefresh: forceRefresh,
    );

    return beneficiaryDTO.map((e) => e.toBeneficiary()).toList(growable: false);
  }
}
