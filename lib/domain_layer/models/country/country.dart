import 'package:equatable/equatable.dart';

///The country data used by the application
class Country extends Equatable {
  /// Country code
  final String? countryCode;

  /// Created on
  final DateTime? createdDate;

  /// Updated on
  final DateTime? updatedDate;

  /// Is iban
  final bool? isIBAN;

  /// Routing code label
  final String? routingCodeLabel;

  /// Country name
  final String? countryName;

  /// Banking
  final bool? banking;

  /// Currency
  final String? currency;

  /// Dial code
  final String? dialCode;

  /// Has RIB
  final bool? hasRIB;

  ///Creates a new [Country]
  Country({
    this.countryCode,
    this.createdDate,
    this.updatedDate,
    this.isIBAN,
    this.routingCodeLabel,
    this.countryName,
    this.banking,
    this.currency,
    this.dialCode,
    this.hasRIB,
  });

  @override
  List<Object?> get props => [
        countryCode,
        createdDate,
        updatedDate,
        isIBAN,
        routingCodeLabel,
        countryName,
        banking,
        currency,
        dialCode,
        hasRIB,
      ];
}
