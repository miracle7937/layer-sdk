import '../../../domain_layer/models.dart';
import '../../dtos.dart';

/// Extension that provides mappings for [OTPStatusDTO]
extension OTPStatusMapper on OTPStatusDTO {
  /// Maps [OTPStatusDTO] into a [OTPStatus] enum
  OTPStatus toOTPStatus() {
    switch (this) {
      case OTPStatusDTO.active:
        return OTPStatus.active;

      case OTPStatusDTO.otp:
        return OTPStatus.otp;

      default:
        return OTPStatus.unknown;
    }
  }
}
