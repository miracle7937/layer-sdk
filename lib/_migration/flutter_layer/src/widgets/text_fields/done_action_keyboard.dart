import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'input_done_view.dart';

/// Widget used when the iOS keyboard is required to show a done button in
/// order for it to close the keyboard
class DoneActionKeyboard extends StatefulWidget {
  /// The child view
  final Widget child;

  /// Custom [String] for the button.
  /// If not provided the default localization will be the one for key `done`
  final String? customButtonTitle;

  /// Creates a new [DoneActionKeyboard]
  const DoneActionKeyboard({
    Key? key,
    required this.child,
    this.customButtonTitle,
  }) : super(key: key);

  @override
  _DoneActionKeyboardState createState() => _DoneActionKeyboardState();
}

class _DoneActionKeyboardState extends State<DoneActionKeyboard> {
  final _controller = KeyboardVisibilityController();
  StreamSubscription<bool>? _subscription;

  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();

    if (Platform.isIOS) {
      _subscription = _controller.onChange.listen(
        (visible) => visible ? showDoneButton(context) : removeDoneButton(),
      );
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;

  /// Adds the done button [OverlayEntry] to the screen
  void showDoneButton(BuildContext context) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: MediaQuery.of(context).viewInsets.bottom -
            InputDoneView.doneViewHeight,
        right: 0.0,
        left: 0.0,
        child: InputDoneView(),
      ),
    );

    Overlay.of(context)!.insert(_overlayEntry!);
  }

  /// Removes the done button [OverlayEntry] from the screen
  void removeDoneButton() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
