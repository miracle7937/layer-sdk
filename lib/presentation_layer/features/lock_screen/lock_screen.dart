import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';

import '../../../domain_layer/models/setting/authentication_settings.dart';
import '../../features.dart';
import '../../widgets.dart';

/// A screen that allows the user to set an access pin.
class LockScreen extends SetAccessPinBaseWidget {
  /// The title to show on the lock screen.
  final String title;

  /// Callback when the user has been authenticated successfully.
  final VoidCallback onAuthenticated;

  /// The authetication settings.
  final AuthenticationSettings authenticationSettings;

  /// Creates a new [LockScreen].
  const LockScreen({
    super.key,
    super.pinLength = 6,
    required this.title,
    required this.onAuthenticated,
    required this.authenticationSettings,
  });

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends SetAccessPinBaseWidgetState<LockScreen> {
  @override
  Widget build(BuildContext context) {
    final layerDesign = DesignSystem.of(context);

    return Scaffold(
      backgroundColor: layerDesign.surfaceOctonary1,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 32.0,
          ),
          child: PinPadView(
            pinLenght: widget.pinLength,
            pin: currentPin,
            title: widget.title,
            disabled: disabled,
            warning: warning,
            onChanged: (pin) {
              currentPin = pin;
              if (pin.length == widget.pinLength) {
                /// Try to authenticate.
              }
            },
            showBiometrics: widget.authenticationSettings.useBiometrics,
            onBiometrics: () {
              /// Try to authenticate.
            },
          ),
        ),
      ),
    );
  }
}
