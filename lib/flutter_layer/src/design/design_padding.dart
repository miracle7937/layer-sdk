import 'package:flutter/material.dart';

import '../design.dart';

/// Sets different paddings depending on the current design size.
class DesignPadding extends StatelessWidget {
  /// The child widget.
  final Widget child;

  /// The style to use to find out the design size.
  ///
  /// Defaults to [DesignStyle.common].
  final DesignStyle style;

  /// The padding to use for each design size.
  ///
  /// If the current design size is not found, [defaultPadding] will be used.
  final Map<DesignSize, EdgeInsets> sizePaddings;

  /// Padding to be used when the design size is not found on the [sizePaddings]
  ///
  /// Defaults to [EdgeInsets.zero].
  final EdgeInsets defaultPadding;

  /// The duration to animate when changing the padding.
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
  const DesignPadding({
    Key? key,
    required this.child,
    this.style = DesignStyle.common,
    required this.sizePaddings,
    this.defaultPadding = EdgeInsets.zero,
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
      padding: sizePaddings[designData.size] ?? defaultPadding,
      child: child,
    );
  }
}
