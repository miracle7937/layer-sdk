/// The type of the second factor authorization.
enum SecondFactorType {
  /// OCRA and OTP.
  ocraOrOTP,

  /// OCRA.
  ocra,

  /// One time sms password.
  otp,

  /// Transaction pin
  pin,

  /// Hardware token
  hardwareToken,
}
