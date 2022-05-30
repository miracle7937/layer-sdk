import 'dart:async';

import 'package:flutter/material.dart';
import 'target/tutorial_step.dart';
import 'widgets/tutorial_widget.dart';

/// Creates a tutorial with focus and steps.
///
/// This is a class, not a widget, so you can use the tutorial class anywhere
/// in the widget tree, you just need to initialize the tutorial with the
/// required parameters and call [Tutorial.show].
///
/// The tutorial uses [Overlay]s with a backdrop shadow for showing the info
/// related to the steps.
/// Also see the [TutorialStep] class.
///
/// The [steps] parameter contains a list of [TutorialStep] items that represent
/// the tutorial stages. When a tutorial step gets pressed the [onStepClick]
/// callback will be called, passing the step.
///
/// When the tutorial is finished, the [onFinish] callback will be called to
/// let you know that the tutorial is no longer showing.
///
/// Each tutorial step has an identifying [GlobalKey] that allows the tutorial
/// to find the widget that the overlay will show relative to. The
/// [focusPadding] parameter is used for indicating the amount of padding
/// between the widget and the overlay. Default will be [10.0].
///
/// You can customize the [shadowColor].By default it will be [Colors.black].
/// You can also customize the [shadowOpacity]. Default will be [0.8].
///
/// For showing the tutorial, you will need to wait for the widget tree to be
/// rendered, so you can use the [WidgetsBinding.addPostFrameCallback] for
/// this.
///
/// {@tool snippet}
/// ```dart
/// /// This key should be passed to the widget that needs to be focused
/// /// on the tutorial.
/// final widgetKey = GlobalKey();
///
/// /// The steps list.
/// final steps = [
///   TutorialStep(
///     keyTarget: widgetKey,
///     contents: [
///       TutorialStepItem(
///         child: Text('test'),
///       ),
///     ],
///   ),
/// ];
///
/// @override
/// void initState() {
///   WidgetsBinding.instance.addPostFrameCallback((_) async {
///     Tutorial(
///       steps: steps,
///       onStepClick: (step) {
///         /// A step was pressed.
///       },
///       onFinish: () async {
///         /// The tutorial finished.
///       },
///     ).show(context);
///   });
/// }
/// ```
/// {@end-tool}
class Tutorial {
  /// The [TutorialStep] list
  final List<TutorialStep> steps;

  /// Called when a step gets clicked
  final FutureOr<void> Function(TutorialStep)? onStepClick;

  /// Called when the tutorial finishes
  final VoidCallback? onFinish;

  /// The padding for the focus
  final double focusPadding;

  /// The shadow's color
  final Color shadowColor;

  /// The shadow's opacity
  final double shadowOpacity;

  /// The [GlobalKey] for the [TutorialWidget] state
  final GlobalKey<TutorialWidgetState> _widgetKey = GlobalKey();

  /// The [OverlayEntry]
  OverlayEntry? _overlayEntry;

  /// Creates a new [Tutorial]
  Tutorial({
    required this.steps,
    this.shadowColor = Colors.black,
    this.onStepClick,
    this.onFinish,
    this.focusPadding = 10,
    this.shadowOpacity = 0.8,
  }) : assert(shadowOpacity >= 0 && shadowOpacity <= 1);

  OverlayEntry _buildOverlay() => OverlayEntry(
        builder: (context) => TutorialWidget(
          key: _widgetKey,
          steps: steps,
          onStepClick: onStepClick,
          focusPadding: focusPadding,
          shadowColor: shadowColor,
          shadowOpacity: shadowOpacity,
          onFinish: _onFinish,
        ),
      );

  /// Shows the [Tutorial]
  void show(BuildContext context, {bool rootOverlay = false}) {
    Future.delayed(Duration.zero, () {
      if (_overlayEntry == null) {
        _overlayEntry = _buildOverlay();
        Overlay.of(context, rootOverlay: rootOverlay)?.insert(_overlayEntry!);
      }
    });
  }

  void _onFinish() {
    onFinish?.call();
    _removeOverlay();
  }

  /// Returns whether the tutorial is showing or not
  bool get isShowing => _overlayEntry != null;

  /// Called for force going to the next tutorial's step
  void next() => _widgetKey.currentState?.next();

  /// Called for force going to the previous tutorial's step
  void previous() => _widgetKey.currentState?.previous();

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
