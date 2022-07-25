import '../../models.dart';

/// Repository responsible for handling all the beneficiaries data.
abstract class BeneficiaryRepositoryInterface {
  /// Lists the beneficiaries.
  ///
  /// Use the [customerId] parameter for loading the beneficiaries related
  /// to that customer.
  ///
  /// The [searchText] field can be used for filtering the beneficiaries.
  ///
  /// Use [limit] and [offset] to paginate.
  Future<List<Beneficiary>> list({
    String? customerId,
    String? searchText,
    int limit = 50,
    int offset = 0,
    bool forceRefresh = false,
  });
}
