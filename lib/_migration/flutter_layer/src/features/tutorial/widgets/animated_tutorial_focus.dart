import 'dart:async';

import 'package:flutter/material.dart';

import '../../../mixins/tutorial_mixin.dart';
import '../paint/back_shadow_painter.dart';
import '../target/tutorial_step.dart';

/// The widget that will show the animation for a [TutorialWidget]
class AnimatedTutorialFocus extends StatefulWidget {
  /// The [TutorialStep] items that will be animated
  final List<TutorialStep> steps;

  /// Called when a step changes
  final ValueSetter<TutorialStep>? onStepChange;

  /// Called when a step is clicked
  final FutureOr<void> Function(TutorialStep)? onStepClick;

  /// Called when a step is removed
  final VoidCallback? onStepRemove;

  /// Called when the tutorial is finished
  final VoidCallback? onFinish;

  /// The shadow's color
  final Color shadowColor;

  /// The shadow's opacity
  final double shadowOpacity;

  /// Creates a new [AnimatedTutorialFocus]
  const AnimatedTutorialFocus({
    Key? key,
    required this.steps,
    this.onStepChange,
    this.onFinish,
    this.onStepRemove,
    this.onStepClick,
    this.shadowColor = Colors.black,
    this.shadowOpacity = 0.8,
  })  : assert(steps.length > 0),
        super(key: key);

  @override
  AnimatedTutorialFocusState createState() => AnimatedTutorialFocusState();
}

/// The [AnimatedTutorialFocus]'s state
class AnimatedTutorialFocusState extends State<AnimatedTutorialFocus>
    with TickerProviderStateMixin, TutorialMixin {
  final _defaultFocusAnimationDuration = const Duration(milliseconds: 600);
  late AnimationController _controller;
  late CurvedAnimation _curvedAnimation;

  TutorialStep get _step => widget.steps[_currentStep];
  Rect? _targetPosition;

  int _currentStep = 0;
  double _progressAnimated = 0;
  bool _shouldGoNextFocus = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _defaultFocusAnimationDuration,
    )..addStatusListener(_listener);

    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.ease,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _runFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// On next step
  void next() => _tapHandler();

  /// On previous step
  void previous() => _tapHandler(shouldGoNextFocus: false);

  Future _tapHandler({
    bool shouldGoNextFocus = true,
    bool shouldCallOnStepClick = false,
  }) async {
    if (shouldCallOnStepClick) {
      await widget.onStepClick?.call(_step);
    }

    setState(() => _shouldGoNextFocus = shouldGoNextFocus);
    _controller.reverse();
  }

  void _nextFocus() {
    if (_currentStep >= widget.steps.length - 1) {
      _finish();
      return;
    }
    _currentStep++;

    _runFocus();
  }

  void _previousFocus() {
    if (_currentStep == 0) {
      return;
    }

    _currentStep--;
    _runFocus();
  }

  void _finish() => widget.onFinish!();

  void _runFocus() {
    if (_currentStep < 0 || _currentStep > widget.steps.length - 1) return;

    _controller.duration = _defaultFocusAnimationDuration;

    var targetPosition = getStepTargetPosition(_step);

    if (targetPosition == null) {
      _finish();
      return;
    }

    setState(() => _targetPosition = targetPosition);

    _controller.forward();
  }

  void _listener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      if (widget.onStepChange != null) {
        widget.onStepChange!(_step);
      }
    }
    if (status == AnimationStatus.dismissed) {
      if (_shouldGoNextFocus) {
        _nextFocus();
      } else {
        _previousFocus();
      }
    }

    if (status == AnimationStatus.reverse) {
      widget.onStepRemove!();
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => _tapHandler(shouldCallOnStepClick: true),
        onPanUpdate: (details) {
          if (details.delta.dx > 0 ||
              details.delta.dx < 0 ||
              details.delta.dy > 0 ||
              details.delta.dy < 0) {
            _tapHandler(shouldGoNextFocus: true);
          }
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, child) {
            _progressAnimated = _curvedAnimation.value;
            return Stack(
              children: <Widget>[
                Container(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  child: CustomPaint(
                    painter: BackShadowPainter(
                      shadowColor: widget.shadowColor,
                      progress: _progressAnimated,
                      target: _targetPosition ?? Offset.zero & Size.zero,
                      shadowOpactiy: widget.shadowOpacity,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
}
