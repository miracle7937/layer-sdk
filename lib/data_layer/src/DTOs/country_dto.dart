/// Represents the Country object
class CountryDTO {
  /// Country code
  String? countryCode;

  /// Created time
  int? tsCreated;

  /// Updated time
  int? tsUpdated;

  /// Is iban
  bool? isIBAN;

  /// Routing code label
  String? routingCodeLabel;

  /// Country name
  String? countryName;

  /// Banking
  bool? banking;

  /// Currency
  String? currency;

  /// Dial code
  String? dialCode;

  /// Has RIB
  bool? hasRIB;

  /// Creates a [CountryDTO] from a JSON
  CountryDTO.fromJson(Map<String, dynamic> json) {
    countryCode = json["country_code"];
    tsCreated = json["ts_created"];
    tsUpdated = json["ts_updated"];
    isIBAN = json["iban"] == null ? true : json["iban"];
    routingCodeLabel = json["routing_code"];
    countryName = json["country_name"];
    banking = json["banking"] ?? true;
    currency = json["currency"];
    dialCode = json["dial_code"];
    hasRIB = json['rib'] ?? false;
  }

  /// Creates a list of [Country] from a JSON list
  static List<CountryDTO> fromJsonList(List json) =>
      json.map((country) => CountryDTO.fromJson(country)).toList();
}
