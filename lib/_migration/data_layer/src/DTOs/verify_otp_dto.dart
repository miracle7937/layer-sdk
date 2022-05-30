/// A data transfer object representing the id and value of the OTP 2FA.
class VerifyOtpDTO {
  /// The identifier of the OTP.
  int? otpId;

  /// The value of the OTP.
  String? value;

  /// Creates [VerifyOtpDTO].
  VerifyOtpDTO({
    this.otpId,
    this.value,
  });

  /// Returns a json representation of the DTO.
  Map<String, dynamic> toJson() => {
        'otp_id': otpId,
        'value': value,
      };
}
