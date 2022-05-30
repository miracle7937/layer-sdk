import 'package:collection/collection.dart';

import '../helpers.dart';

/// TODO: Copied as is from Core-models, could be done differently
class SecondFactorDTO extends EnumDTO {
  /// second factor is one time password
  static const otp = SecondFactorDTO._internal('OTP');

  /// second factor is pin
  static const pin = SecondFactorDTO._internal('PIN');

  /// second factor is hardware token
  static const hardwareToken = SecondFactorDTO._internal('HW_TOKEN');

  /// second factor is OTP + pin
  static const otpPin = SecondFactorDTO._internal("OTP_PIN");

  /// second factor is pin + hardware token
  static const pinHardwareToken = SecondFactorDTO._internal("PIN,HW_TOKEN");

  /// second factor is otp + hardware token
  static const otpPinHardwareToken =
      SecondFactorDTO._internal("OTP_PIN,HW_TOKEN");

  /// All the available second factor values in a list
  static const List<SecondFactorDTO> values = [
    otp,
    pin,
    hardwareToken,
    otpPin,
    pinHardwareToken,
    otpPinHardwareToken,
  ];

  const SecondFactorDTO._internal(String value) : super.internal(value);

  /// Creates a [SecondFactorDTO] from a [String]
  static SecondFactorDTO? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => compareCommaSeparatedElements(val.value, raw),
      );
}
