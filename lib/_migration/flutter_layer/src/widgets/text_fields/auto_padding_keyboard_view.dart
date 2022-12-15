import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../../../../../presentation_layer/resources.dart';

/// View that will add/remove a padding to the child view when
/// the keyboard is shown/hidden
class AutoPaddingKeyboard extends StatelessWidget {
  /// The child view
  final Widget child;

  /// Creates a new [AutoPaddingKeyboard]
  const AutoPaddingKeyboard({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) => AnimatedContainer(
          duration: Duration(milliseconds: 300),
          color: AppTheme.of(context)
              .toThemeData()
              .backgroundColor
              .withOpacity(0.8),
          padding: EdgeInsets.only(
            bottom: isKeyboardVisible && Platform.isIOS ? 8 : 0.0,
          ),
          child: child,
        ),
      );
}
