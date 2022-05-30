import 'package:flutter/material.dart';

/// A widget that detects taps outside focusable fields
/// in the subtree and hides keyboard.
class AutoHideKeyboard extends StatelessWidget {
  /// The widget below this widget in the tree.
  final Widget? child;

  /// Creates [AutoHideKeyboard] widget.
  const AutoHideKeyboard({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: child,
    );
  }
}
