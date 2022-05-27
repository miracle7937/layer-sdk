import '../../extensions.dart';
import '../../models.dart';
import '../dtos.dart';

///Extension for mapping the [CountryDTO]
extension CountryDTOMapping on CountryDTO {
  ///Maps an [CountryDTO] into an [Country]
  Country toCountry() => Country(
        countryCode: countryCode,
        createdDate: tsCreated?.toDateTimeFromMilliseconds(),
        updatedDate: tsUpdated?.toDateTimeFromMilliseconds(),
        isIBAN: isIBAN,
        routingCodeLabel: routingCodeLabel,
        countryName: countryName,
        banking: banking,
        currency: currency,
        dialCode: dialCode,
        hasRIB: hasRIB,
      );
}
