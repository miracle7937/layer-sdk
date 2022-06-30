import 'package:collection/collection.dart';

import '../../helpers.dart';

/// Maps the status of a request that requires OTP
class OTPStatusDTO extends EnumDTO {
  const OTPStatusDTO._internal(String value) : super.internal(value);

  /// If the second factor value is required
  static const otp = OTPStatusDTO._internal('O');

  /// If the second factor value is not needed
  static const active = OTPStatusDTO._internal('A');

  /// A List of all possible status
  static const List<OTPStatusDTO> values = [
    otp,
    active,
  ];

  /// Parse a string to its respective status
  static OTPStatusDTO? fromRaw(String? raw) =>
      values.firstWhereOrNull((it) => it.value == raw);
}
