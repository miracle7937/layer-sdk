import 'package:equatable/equatable.dart';

/// All available Second Factor authentication methods
enum SecondFactorMethod {
  /// One time password
  otp,
}

/// All available errors for [SecondFactorCubit]
enum SecondFactorErrors {
  /// No errors
  none,

  /// Network error
  network,

  /// Generic error
  generic,

  /// The supplied OTP value is wrong.
  wrongOTP,

  /// The re-send OTP request failed.
  resendOTPFailed,
}

///
class SecondFactorState extends Equatable {
  /// The current OTP id.
  final int? otpId;

  /// The device ID this cubit is verifying 2FA on.
  final int deviceId;

  /// The 2FA method used by this cubit.
  final SecondFactorMethod method;

  /// Whether or not the 2FA was validated.
  final bool validated;

  /// Whether or not the cubit is busy validating the 2FA.
  final bool busy;

  /// Whether or not the cubit is busy requesting a new OTP.
  final bool busyResendingOTP;

  /// The current error status.
  final SecondFactorErrors error;

  /// Creates a new [SecondFactorState] instance.
  const SecondFactorState({
    required this.deviceId,
    this.otpId,
    this.method = SecondFactorMethod.otp,
    this.validated = false,
    this.busy = false,
    this.busyResendingOTP = false,
    this.error = SecondFactorErrors.none,
  });

  /// Creates a new [SecondFactorState] from the provided parameters.
  SecondFactorState copyWith({
    int? otpId,
    int? deviceId,
    SecondFactorMethod? method,
    bool? validated,
    bool? busy,
    bool? busyResendingOTP,
    SecondFactorErrors? error,
  }) {
    return SecondFactorState(
      otpId: otpId ?? this.otpId,
      deviceId: deviceId ?? this.deviceId,
      method: method ?? this.method,
      validated: validated ?? this.validated,
      busy: busy ?? this.busy,
      busyResendingOTP: busyResendingOTP ?? this.busyResendingOTP,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [
        deviceId,
        method,
        validated,
        busy,
        busyResendingOTP,
        error,
      ];
}
