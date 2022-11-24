import 'package:flutter/material.dart';

/// A widget that handles hiding keyboard on tap for its entire widget subtree.
class GlobalAutoHideKeyboard extends StatefulWidget {
  /// The widget child.
  final Widget child;

  /// The maximum distance between the pointer down and pointer up events
  /// before the event is no longer considered a "tap".
  final double maxTriggerDistance;

  /// The maximum time in milliseconds for between the pointer down and pointer
  /// up events before the event is no longer considered a tap.
  final int maxTapTime;

  /// Allows to enable / disable the pointer event listener.
  final bool enabled;

  /// Creates new [GlobalAutoHideKeyboard].
  const GlobalAutoHideKeyboard({
    super.key,
    required this.child,
    this.maxTriggerDistance = 20,
    this.maxTapTime = 400,
    this.enabled = true,
  });

  @override
  State<GlobalAutoHideKeyboard> createState() => _GlobalAutoHideKeyboardState();
}

class _GlobalAutoHideKeyboardState extends State<GlobalAutoHideKeyboard> {
  PointerDownEvent? downEvent;

  @override
  Widget build(BuildContext context) {
    if (widget.enabled) {
      return Listener(
        onPointerDown: (event) => downEvent = event,
        onPointerUp: _hideKeyboardIfNeeded,
        child: widget.child,
      );
    }
    return widget.child;
  }

  void _hideKeyboardIfNeeded(PointerUpEvent upEvent) {
    if (downEvent == null) return;

    final distance =
        (downEvent!.localPosition - upEvent.localPosition).distance;
    final timeElapsed =
        (upEvent.timeStamp - downEvent!.timeStamp).inMilliseconds;

    final distanceValid = distance < widget.maxTriggerDistance;
    final timestampValid = timeElapsed < widget.maxTapTime;

    if (distanceValid && timestampValid) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
