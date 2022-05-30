/// The status of a OTP request
enum OTPStatus {
  /// Second factor is required
  otp,

  /// Second factor is not required
  active,

  /// unknown status
  unknown
}
