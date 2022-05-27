import '../../models.dart';
import '../../providers.dart';
import '../mappings.dart';

/// Handles all the countries data
class CountryRepository {
  ///The country provider
  final CountryProvider _provider;

  ///Creates a new repository with the supplied [CountryProvider]
  CountryRepository({
    required CountryProvider provider,
  }) : _provider = provider;

  ///Lists the categories
  Future<List<Country>> list({
    bool registration = false,
    bool forceRefresh = false,
  }) async {
    final countryDTOs = await _provider.list(
      registration: registration,
      forceRefresh: forceRefresh,
    );

    return countryDTOs
        .map(
          (e) => e.toCountry(),
        )
        .toList();
  }
}
