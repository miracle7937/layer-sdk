import 'package:collection/collection.dart';

import '../../helpers.dart';

/// TODO: Copied as is from Core-models, could be done differently
class SecondFactorTypeDTO extends EnumDTO {
  /// second factor is one time password
  static const otp = SecondFactorTypeDTO._internal('OTP');

  /// second factor is pin
  static const pin = SecondFactorTypeDTO._internal('PIN');

  /// second factor is hardware token
  static const hardwareToken = SecondFactorTypeDTO._internal('HW_TOKEN');

  /// second factor is OTP + pin
  static const otpPin = SecondFactorTypeDTO._internal("OTP_PIN");

  /// second factor is pin + hardware token
  static const pinHardwareToken = SecondFactorTypeDTO._internal("PIN,HW_TOKEN");

  /// second factor is ocra OR pin
  static const ocraOrOTP = SecondFactorTypeDTO._internal("OCRA,OTP");

  /// second factor is ocra
  static const ocra = SecondFactorTypeDTO._internal("OCRA");

  /// second factor is otp + hardware token
  static const otpPinHardwareToken =
      SecondFactorTypeDTO._internal("OTP_PIN,HW_TOKEN");

  /// Second factor is OCRA or OTP.
  static const ocraOrOTP = SecondFactorTypeDTO._internal('OCRA,OTP');

  /// Second factor is OCRA.
  static const ocra = SecondFactorTypeDTO._internal('OCRA');

  /// All the available second factor values in a list
  static const List<SecondFactorTypeDTO> values = [
    otp,
    pin,
    hardwareToken,
    otpPin,
    pinHardwareToken,
    ocraOrOTP,
    ocra,
    otpPinHardwareToken,
    ocraOrOTP,
    ocra,
  ];

  const SecondFactorTypeDTO._internal(String value) : super.internal(value);

  /// Creates a [SecondFactorTypeDTO] from a [String]
  static SecondFactorTypeDTO? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => compareCommaSeparatedElements(val.value, raw),
      );
}
