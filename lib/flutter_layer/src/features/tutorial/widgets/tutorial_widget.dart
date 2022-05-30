import 'dart:async';

import 'package:flutter/material.dart';

import '../../../mixins/tutorial_mixin.dart';
import '../target/tutorial_step.dart';
import '../target/tutorial_step_item.dart';
import '../tutorial_controller.dart';
import 'animated_tutorial_focus.dart';

/// The tutorial widget
class TutorialWidget extends StatefulWidget {
  /// The [TutorialStep] list
  final List<TutorialStep> steps;

  /// Called when a step gets clicked
  final FutureOr<void> Function(TutorialStep)? onStepClick;

  /// Called when the tutorial finishes
  final VoidCallback? onFinish;

  /// The shadow's color
  final Color shadowColor;

  /// The shadow's opacity
  final double shadowOpacity;

  /// The padding for the focus
  final double focusPadding;

  /// Creates a new [TutorialWidget]
  const TutorialWidget({
    Key? key,
    required this.steps,
    this.onFinish,
    this.focusPadding = 20,
    this.onStepClick,
    this.shadowColor = Colors.black,
    this.shadowOpacity = 0.8,
  })  : assert(steps.length > 0),
        super(key: key);

  @override
  TutorialWidgetState createState() => TutorialWidgetState();
}

/// The [TutorialWidget]'s state
class TutorialWidgetState extends State<TutorialWidget>
    with TutorialMixin
    implements TutorialController {
  final GlobalKey<AnimatedTutorialFocusState> _focusLightKey = GlobalKey();
  bool _showContent = false;
  TutorialStep? _currentStep;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: <Widget>[
          AnimatedTutorialFocus(
            key: _focusLightKey,
            steps: widget.steps,
            onFinish: widget.onFinish,
            shadowColor: widget.shadowColor,
            shadowOpacity: widget.shadowOpacity,
            onStepClick: (step) => widget.onStepClick?.call(step),
            onStepChange: (step) {
              setState(() {
                _currentStep = step;
                _showContent = true;
              });
            },
            onStepRemove: () => setState(() => _showContent = false),
          ),
          AnimatedOpacity(
            opacity: _showContent ? 1 : 0,
            duration: Duration(milliseconds: 300),
            child: _buildContents(),
          ),
        ],
      ),
    );
  }

  Widget _buildContents() {
    if (_currentStep == null) {
      return SizedBox.shrink();
    }

    var children = <Widget>[];

    final target = getStepTargetPosition(_currentStep!);
    if (target == null) {
      return SizedBox.shrink();
    }

    var positioned = Offset(
      target.topLeft.dx + target.size.width / 2,
      target.topLeft.dy + target.size.height / 2,
    );

    final haloWidth = target.size.width / 2 + widget.focusPadding;
    final haloHeight = target.size.height / 2 + widget.focusPadding;

    var weight = 0.0;
    double? top;
    double? bottom;
    double? left;

    children = _currentStep!.contents.map<Widget>((i) {
      switch (i.alignment) {
        case TutorialItemAlignment.bottom:
          weight = MediaQuery.of(context).size.width;
          left = 0;
          top = positioned.dy + haloHeight;
          break;

        case TutorialItemAlignment.top:
          weight = MediaQuery.of(context).size.width;
          left = 0;
          bottom =
              haloHeight + (MediaQuery.of(context).size.height - positioned.dy);
          break;

        case TutorialItemAlignment.left:
          weight = positioned.dx - haloWidth;
          left = 0;
          top = positioned.dy - target.size.height / 2 - haloHeight;
          break;

        case TutorialItemAlignment.right:
          left = positioned.dx + haloWidth;
          top = positioned.dy - target.size.height / 2 - haloHeight;
          weight = MediaQuery.of(context).size.width - left!;
          break;

        case TutorialItemAlignment.center:
          weight = MediaQuery.of(context).size.width;
          top = MediaQuery.of(context).size.height / 2 - positioned.dx / 2;

          ///The centered item is overlaping the target
          if ((top! + positioned.dx / 2) >
              (positioned.dy - target.size.height / 2)) {
            top = 40;
            left = 0;
          }
          break;

        case TutorialItemAlignment.overlap:
          left = positioned.dx - target.size.width / 2;
          top = positioned.dy - target.size.height / 2;
          weight = MediaQuery.of(context).size.width - left!;
          break;

        case TutorialItemAlignment.pinned:
          weight = MediaQuery.of(context).size.width;
          left = 0;
          top = 0;
          break;
      }

      return Positioned(
        top: top,
        bottom: bottom,
        left: left,
        child: IgnorePointer(
          child: Container(
            width: weight,
            child: Padding(
              padding: i.padding,
              child: i.builder != null
                  ? i.builder?.call(context, this)
                  : (i.child ?? SizedBox.shrink()),
            ),
          ),
        ),
      );
    }).toList();

    return Stack(
      children: children,
    );
  }

  void next() => _focusLightKey.currentState?.next();

  void previous() => _focusLightKey.currentState?.previous();
}
