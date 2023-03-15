import 'package:flutter/material.dart';

/// A widget that displays a progress bar.
class ProgressBar extends StatelessWidget {
  /// The color for the filled part of the bar.
  final Color fillColor;

  /// The color for the not filled part of the bar.
  final Color backgroundColor;

  /// The bar border radius.
  final BorderRadius? borderRadius;

  /// The value of range [0 - 1] that represents how much of the bar is filled.
  final double value;

  /// The height of the bar.
  final double height;

  /// The width of the bar.
  final double? width;

  /// Creates [ProgressBar].
  const ProgressBar({
    Key? key,
    required this.fillColor,
    required this.backgroundColor,
    this.borderRadius,
    required this.value,
    required this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Container(
        height: height,
        width: width,
        child: Row(
          children: [
            Flexible(
              flex: (value.clamp(0, 1) * 100).toInt(),
              child: Container(color: fillColor),
            ),
            Flexible(
              flex: ((1 - value.clamp(0, 1)) * 100).toInt(),
              child: Container(color: backgroundColor),
            ),
          ],
        ),
      ),
    );
  }
}
