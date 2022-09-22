import '../../models.dart';

/// Repository responsible for handling all the banks data.
abstract class BankRepositoryInterface {
  /// Lists the banks for the provided country code.
  ///
  /// Use the [limit] and [offset] parameters for pagination purposes.
  /// The [query] parameter can bu used for filtering the results.
  Future<List<Bank>> listByCountryCode({
    required String countryCode,
    int? limit,
    int? offset,
    String? query,
    bool forceRefresh = false,
  });
}
