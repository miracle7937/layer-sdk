/// The type of the second factor authorization.
enum SecondFactorType {
  /// Biometrics and OTP.
  biometricsOrOTP,

  /// One time sms password.
  otp,

  /// Transaction pin
  pin,

  /// Hardware token
  hardwareToken,
}
