import '../../dtos.dart';
import '../../helpers.dart';
import '../../network.dart';

/// Provides data about the countries
class CountryProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  /// Creates a new [CountryProvider] with the supplied netClient.
  CountryProvider(
    this.netClient,
  );

  /// Returns a list of countries.
  Future<List<CountryDTO>> list({
    bool registration = false,
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.country,
      method: NetRequestMethods.get,
      queryParameters: {
        if (registration) 'registration': true,
      },
      forceRefresh: forceRefresh,
    );

    return getSortedCountries(CountryDTO.fromJsonList(
      List<Map<String, dynamic>>.from(response.data),
    ));
  }

  /// Returns the list of countries sorted
  List<CountryDTO> getSortedCountries(
    List<CountryDTO> countries,
  ) {
    countries
        .sort((a, b) => (isNotEmpty(a.countryName) && isNotEmpty(b.countryName))
            ? (a.countryName!.compareTo(b.countryName!))
            : isEmpty(b.countryName)
                ? -1
                : 1);
    return countries;
  }
}
