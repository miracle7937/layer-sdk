import 'package:equatable/equatable.dart';

/// Holds the information of a passport.
class Passport extends Equatable {
  /// The passport number.
  ///
  /// Defaults to an empty string.
  final String number;

  /// The date the passport was issued. Can be null.
  final DateTime? issuanceDate;

  /// The date the passport will expire. Can be null.
  final DateTime? expirationDate;

  /// The country that issued the passport.
  ///
  /// Defaults to an empty string.
  final String issuanceCountry;

  /// A better description of the issuance country.
  ///
  /// Defaults to an empty string.
  final String issuanceCountryDescription;

  /// Creates a new [Passport].
  const Passport({
    this.number = '',
    this.issuanceDate,
    this.expirationDate,
    this.issuanceCountry = '',
    this.issuanceCountryDescription = '',
  });

  /// Returns if there's no passport data.
  bool get isEmpty =>
      number.isEmpty &&
      issuanceDate == null &&
      expirationDate == null &&
      issuanceCountry.isEmpty &&
      issuanceCountryDescription.isEmpty;

  @override
  List<Object?> get props => [
        number,
        issuanceDate,
        expirationDate,
        issuanceCountry,
        issuanceCountryDescription,
      ];

  /// Returns a copy of this passport with select different values.
  Passport copyWith({
    String? number,
    DateTime? issuanceDate,
    DateTime? expirationDate,
    String? issuanceCountry,
    String? issuanceCountryDescription,
  }) =>
      Passport(
        number: number ?? this.number,
        issuanceDate: issuanceDate ?? this.issuanceDate,
        expirationDate: expirationDate ?? this.expirationDate,
        issuanceCountry: issuanceCountry ?? this.issuanceCountry,
        issuanceCountryDescription:
            issuanceCountryDescription ?? this.issuanceCountryDescription,
      );
}
