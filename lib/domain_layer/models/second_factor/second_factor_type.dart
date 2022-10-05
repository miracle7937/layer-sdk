/// The type of the second factor authorization.
enum SecondFactorType {
  /// One time sms password.
  otp,

  /// Transaction pin
  pin,

  /// Hardware token
  hardwareToken,

  /// Ocra or OTP
  ocraOrOTP,

  /// Ocra
  ocra,
}
