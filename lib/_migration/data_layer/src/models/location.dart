import 'package:equatable/equatable.dart';

/// Keeps the data associated with a location
class Location extends Equatable {
  /// The city name.
  final String? city;

  /// The continent name.
  final String? continent;

  /// THe country name.
  final String? country;

  /// The ISO code for the country.
  final String? countryISO;

  /// The latitude.
  final double? latitude;

  /// The longitude.
  final double? longitude;

  /// Creates a new [Location].
  Location({
    this.city,
    this.continent,
    this.country,
    this.countryISO,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [
        city,
        continent,
        country,
        countryISO,
        latitude,
        longitude,
      ];

  /// Creates a new location based on this one.
  Location copyWith({
    String? city,
    String? continent,
    String? country,
    String? countryISO,
    double? latitude,
    double? longitude,
  }) =>
      Location(
        city: city ?? this.city,
        continent: continent ?? this.continent,
        country: country ?? this.country,
        countryISO: countryISO ?? this.countryISO,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
      );
}
