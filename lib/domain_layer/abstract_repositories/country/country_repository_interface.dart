import '../../models.dart';

/// An abstract repository for the countries
abstract class CountryRepositoryInterface {
  /// List the countries
  Future<List<Country>> list({
    bool registration = false,
    bool forceRefresh = false,
  });
}
