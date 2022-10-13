import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain_layer/models.dart';
import '../../cubits.dart';
import '../../features.dart';
import '../../mixins.dart';
import '../../utils.dart';
import '../../widgets.dart';

/// The available second factor input types.
enum SecondFactorInputType {
  /// OTP Code.
  otpCode,

  /// OCRA client response.
  ocraClientResponse,
}

/// Model that represents a value inputed on the second factor screen.
class SecondFactorScreenInput extends Equatable {
  /// The second factor input type.
  final SecondFactorInputType inputType;

  /// The inputed value.
  final String value;

  /// Creates a new [SecondFactorScreenInput].
  const SecondFactorScreenInput({
    required this.inputType,
    required this.value,
  });

  @override
  List<Object?> get props => [
        inputType,
        value,
      ];
}

/// A screen that will show a second factor flow depending on the passed
/// second factor type.
class SecondFactorScreen<LayerCubit extends Cubit<BaseState>, LayerCubitAction>
    extends StatelessWidget with FullScreenLoaderMixin {
  /// The second factor type.
  final SecondFactorType secondFactorType;

  /// The second factor screen configuration.
  final SecondFactorScreenConfiguration<LayerCubitAction>
      secondFactorScreenConfiguration;

  /// The set of cubit actions that should be handled by the second factor
  /// screen.
  final UnmodifiableSetView<LayerCubitAction> errorActions;

  /// The cubit action that should be handled when the user introduces an
  /// incorrect value on the second factor screen.
  final LayerCubitAction incorrectValueErrorAction;

  /// The callback called when the user inputs a value on the corresponding
  /// second factor screen.
  ///
  /// You receive a [SecondFactorScreenInput] element containing the type
  /// of inputed value and the string value itself.
  ///
  /// It should return wheter if the verify second factor request succeeded or
  /// not.
  final Future<bool> Function(SecondFactorScreenInput) onValueInputed;

  /// Creates a new [SecondFactorScreen].
  SecondFactorScreen({
    Key? key,
    required this.secondFactorType,
    required this.secondFactorScreenConfiguration,
    Set<LayerCubitAction> errorActions = const {},
    required this.incorrectValueErrorAction,
    required this.onValueInputed,
  })  : errorActions = UnmodifiableSetView(errorActions),
        super(key: key);

  @override
  Widget build(BuildContext context) =>
      CubitErrorListener<LayerCubit, LayerCubitAction>(
        actions: errorActions,
        onConnectivityError: (error) => _onCubitError(context, error),
        onAPIError: (error) => _onCubitError(context, error),
        onCustomError: (error) => _onCubitError(context, error),
        child: _buildSecondFactorView(context),
      );

  /// Builds the second factor view.
  Widget _buildSecondFactorView(
    BuildContext context,
  ) {
    switch (secondFactorType) {
      case SecondFactorType.ocraOrOTP:
      case SecondFactorType.otp:
        assert(
          secondFactorScreenConfiguration.ocraOtpConfiguration != null,
          'The second factor type is $secondFactorType but the '
          'ocraOtpConfiguration is null',
        );

        assert(
          secondFactorType == SecondFactorType.otp ||
              secondFactorScreenConfiguration
                      .ocraOtpConfiguration?.onSendOTPCode !=
                  null,
          'The second factor type is $secondFactorType but the callback for '
          'sendign an OTP code is null',
        );

        return LayerOcraOtpScreen<LayerCubit, LayerCubitAction>(
          secondFactorType: secondFactorType,
          errorActions: errorActions,
          incorrectValueErrorAction: incorrectValueErrorAction,
          ocraOtpConfiguration:
              secondFactorScreenConfiguration.ocraOtpConfiguration!,
          onOTPCode: (code) => _onValueInputed(
            context,
            inputType: SecondFactorInputType.otpCode,
            value: code,
          ),
          onOCRAClientResponse: (clientResponse) => _onValueInputed(
            context,
            inputType: SecondFactorInputType.ocraClientResponse,
            value: clientResponse,
          ),
        );

      default:
        throw Exception(
          '$runtimeType | Unhandled second factor type: $secondFactorType',
        );
    }
  }

  /// Handles a second factor value inputed.
  Future<void> _onValueInputed(
    BuildContext context, {
    required SecondFactorInputType inputType,
    required String value,
  }) async {
    /// Shows the fullscreen loader.
    showFullScreenLoader(context);

    final success = await onValueInputed(SecondFactorScreenInput(
      inputType: inputType,
      value: value,
    ));

    /// Hides the fullscreen loader.
    Navigator.pop(context);

    if (success) {
      /// Closes the screen.
      Navigator.pop(context);
    }
  }

  /// Handles the cubit errors.
  void _onCubitError(
    BuildContext context,
    CubitError error,
  ) {
    if (error is CubitConnectivityError) {
      _showErrorBottomSheet(context, titleKey: 'connectivity_error');
    } else if (error is CubitAPIError || error is CubitCustomError) {
      final apiError = error is CubitAPIError
          ? error as CubitAPIError<LayerCubitAction>
          : null;

      final customError = error is CubitCustomError
          ? error as CubitCustomError<LayerCubitAction>
          : null;

      final code = apiError?.code ?? customError?.code;
      final message = apiError?.message ?? customError?.message;

      if (code != CubitErrorCode.incorrectOTPCode) {
        _showErrorBottomSheet(
          context,
          titleKey: code?.value ?? 'generic_error',
          descriptionKey: message,
        );
      }
    } else {
      throw Exception(
        '$runtimeType | Unhandled CubitError type: '
        '${error.runtimeType}',
      );
    }
  }

  /// Shows an error bottom sheet for the resend OTP code.
  Future<void> _showErrorBottomSheet(
    BuildContext context, {
    required String titleKey,
    String? descriptionKey,
  }) =>
      BottomSheetHelper.showError(
        context: context,
        titleKey: titleKey,
        descriptionKey: descriptionKey,
        dismissKey: 'retry',
        blurBackground: true,
      );
}

/// A second factor screen for handleing the OCRA and/or OTP type.
class LayerOcraOtpScreen<LayerCubit extends Cubit<BaseState>, LayerCubitAction>
    extends StatelessWidget {
  /// The second factor type.
  ///
  /// If this is [SecondFactorType.biometricsOrOTP], the view will try to
  /// launch the biometrics for the OCRA challenge.
  final SecondFactorType secondFactorType;

  /// The set of cubit actions that should be handled by the second factor
  /// screen.
  final UnmodifiableSetView<LayerCubitAction> errorActions;

  /// The cubit action that should be handled when the user introduces an
  /// incorrect value on the second factor screen.
  final LayerCubitAction incorrectValueErrorAction;

  /// The configuration for this second factor view.
  final OcraOtpConfiguration<LayerCubitAction> ocraOtpConfiguration;

  /// The callback called when an OTP code is setted.
  final ValueSetter<String> onOTPCode;

  /// The callback called when the biometrics are introduced and the
  /// OCRA challenge is obtained.
  final ValueSetter<String> onOCRAClientResponse;

  /// Creates a new [LayerOcraOtpScreen].
  LayerOcraOtpScreen({
    Key? key,
    required this.secondFactorType,
    Set<LayerCubitAction> errorActions = const {},
    required this.incorrectValueErrorAction,
    required this.ocraOtpConfiguration,
    required this.onOTPCode,
    required this.onOCRAClientResponse,
  })  : errorActions = UnmodifiableSetView(errorActions),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final translation = Translation.of(context);

    return CubitActionBuilder<LayerCubit, LayerCubitAction>(
      actions: {
        ocraOtpConfiguration.verifyAction,
        ocraOtpConfiguration.resendAction,
      },
      builder: (context, loadingActions) {
        final isVerifying = loadingActions.contains(
          ocraOtpConfiguration.verifyAction,
        );
        final isResending = loadingActions.contains(
          ocraOtpConfiguration.resendAction,
        );

        return CubitErrorBuilder<LayerCubit>(
          builder: (context, cubitErrors) {
            final hasVerificationError = cubitErrors.where(
              (error) {
                final connectivityError = error is CubitConnectivityError
                    ? error as CubitConnectivityError<LayerCubitAction>
                    : null;

                final apiError = error is CubitAPIError
                    ? error as CubitAPIError<LayerCubitAction>
                    : null;

                final customError = error is CubitCustomError
                    ? error as CubitCustomError<LayerCubitAction>
                    : null;

                final action = (connectivityError?.action ??
                    apiError?.action ??
                    customError?.action);

                final code = apiError?.code;

                return action == incorrectValueErrorAction &&
                    code == CubitErrorCode.incorrectOTPCode;
              },
            ).isNotEmpty;

            return OTPScreen(
              title: translation.translate('verification_code'),
              imageBuilder: (context) => ocraOtpConfiguration.otpImageWidget,
              onOTPCode: onOTPCode,
              isVerifying: isVerifying,
              verificationError: hasVerificationError
                  ? translation.translate('wrong_otp_code')
                  : null,
              shouldClearCode: cubitErrors.isNotEmpty,
              onResend: ocraOtpConfiguration.onResend,
              isResending: isResending,
              showBiometrics: secondFactorType == SecondFactorType.ocraOrOTP,
              onOCRAClientResponse: onOCRAClientResponse,
              onSendOTPCode: ocraOtpConfiguration.onSendOTPCode,
            );
          },
        );
      },
    );
  }
}
