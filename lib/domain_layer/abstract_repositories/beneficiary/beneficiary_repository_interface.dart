import '../../models.dart';

/// Repository responsible for handling all the beneficiaries data.
abstract class BeneficiaryRepositoryInterface {
  /// Lists the beneficiaries of the provided `customerId`,
  /// optionally filtering by searchText.
  ///
  /// Use [limit] and [offset] to paginate.
  Future<List<Beneficiary>> list({
    required String customerId,
    String? searchText,
    int limit = 50,
    int offset = 0,
    bool forceRefresh = false,
  });
}
