import 'dart:math';

import 'package:flutter/material.dart';

import '../design.dart';

/// Applies the current design margin for the child widget.
class DesignMargin extends StatelessWidget {
  /// The child widget.
  final Widget child;

  /// The style to use.
  ///
  /// Defaults to [DesignStyle.common].
  final DesignStyle style;

  /// An optional minimum margin.
  final EdgeInsets? minimum;

  /// The duration to animate when changing the margin.
  final Duration duration;

  /// The animation curve to apply.
  ///
  /// Defaults to [Curves.linear]
  final Curve curve;

  /// Called every time an animation completes.
  ///
  /// This can be useful to trigger additional actions (e.g. another animation)
  /// at the end of the current animation.
  final VoidCallback? onEnd;

  /// Creates a new [DesignMargin].
  const DesignMargin({
    Key? key,
    required this.child,
    this.style = DesignStyle.common,
    this.minimum,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.linear,
    this.onEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final designData = DesignAware.of(context, style: style);

    return AnimatedPadding(
      duration: duration,
      curve: curve,
      onEnd: onEnd,
      padding: EdgeInsets.fromLTRB(
        max(minimum?.left ?? 0.0, designData.margin),
        minimum?.top ?? 0.0,
        max(minimum?.right ?? 0.0, designData.margin),
        minimum?.bottom ?? 0.0,
      ),
      child: child,
    );
  }
}
