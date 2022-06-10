import '../../../domain_layer/abstract_repositories/country/country_repository_interface.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Handles all the countries data
class CountryRepository implements CountryRepositoryInterface {
  ///The country provider
  final CountryProvider _provider;

  ///Creates a new repository with the supplied [CountryProvider]
  CountryRepository({
    required CountryProvider provider,
  }) : _provider = provider;

  ///Lists the countries
  @override
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
