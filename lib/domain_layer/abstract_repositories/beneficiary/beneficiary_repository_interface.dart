import '../../models.dart';

/// Repository responsible for handling all the beneficiaries data.
abstract class BeneficiaryRepositoryInterface {
  /// Lists the beneficiaries.
  /// Of the provided `customerId`, if passed.
  /// Optionally filtering by searchText.
  ///
  /// Use [limit] and [offset] to paginate.
  Future<List<Beneficiary>> list({
    String? customerId,
    String? searchText,
    int limit = 50,
    int offset = 0,
    bool forceRefresh = false,
    bool activeOnly = false,
  });

  /// Deletes the beneficiary with the provided id.
  Future<Beneficiary> delete({
    required int id,
  });
}
