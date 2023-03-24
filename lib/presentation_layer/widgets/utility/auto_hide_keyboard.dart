import 'package:flutter/material.dart';

/// A widget that detects taps outside focusable fields
/// in the subtree and hides keyboard.
class AutoHideKeyboard extends StatelessWidget {
  /// The child.
  final Widget? child;

  /// Creates [AutoHideKeyboard] widget.
  const AutoHideKeyboard({
    Key? key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: child,
      );
}
