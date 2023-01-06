import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';

/// A wrapper class for the `flutter_libphonenumber` library. It allows to
/// easily mock the `CountryWithPhoneCode.getCountryDataByPhone` method for
/// testing.
class CountryWithPhoneCodeWrapper {
  /// Try to guess country from phone
  CountryWithPhoneCode? getCountryDataByPhone(
    String phone, {
    int? subscringLength,
  }) =>
      CountryWithPhoneCode.getCountryDataByPhone(phone);
}
