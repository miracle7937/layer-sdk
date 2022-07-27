import '../../models.dart';

/// Repository responsible for handling all the banks data.
abstract class BankRepositoryInterface {
  /// Lists the banks for the provided country code.
  Future<List<Bank>> listByCountryCode({
    required String countryCode,
    bool forceRefresh = false,
  });
}
