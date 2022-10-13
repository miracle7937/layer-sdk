import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Model that represents the configuration for the second factor screen.
class SecondFactorScreenConfiguration<LayerCubitAction> extends Equatable {
  /// The configuration for the OCRA/OTP second factor.
  final OcraOtpConfiguration<LayerCubitAction>? ocraOtpConfiguration;

  /// Creates a new [SecondFactorScreenConfiguration].
  const SecondFactorScreenConfiguration({
    this.ocraOtpConfiguration,
  });

  @override
  List<Object?> get props => [
        ocraOtpConfiguration,
      ];
}

/// Model repesenting the configuration for the OCRA/OTP second factor.
///
/// This type of configuration should be used for when the second factor type
/// is OCRA/OTP or only OTP.
class OcraOtpConfiguration<LayerCubitAction> extends Equatable {
  /// The cubit action for verifying the OTP.
  final LayerCubitAction verifyAction;

  /// The cubit action for resending the OTP.
  final LayerCubitAction resendAction;

  /// The image widget to show for the OTP.
  final Widget otpImageWidget;

  /// The callback called when the send otp code button gets pressed.
  final Future<bool> Function()? onSendOTPCode;

  /// The callback called when the user presses on the resend button.
  final VoidCallback onResend;

  /// Creates a new [OcraOtpConfiguration].
  const OcraOtpConfiguration({
    required this.verifyAction,
    required this.resendAction,
    required this.otpImageWidget,
    this.onSendOTPCode,
    required this.onResend,
  });

  @override
  List<Object?> get props => [
        verifyAction,
        resendAction,
        otpImageWidget,
        onSendOTPCode,
        onResend,
      ];
}
