import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';

/// Widget that exposes a way to refresh the data for the passed [child].
class PullToRefresh extends StatelessWidget {
  /// Callback for refreshing the data.
  final Future<void> Function() onRefresh;

  /// The child.
  final Widget child;

  /// Creates a new [PullToRefresh].
  const PullToRefresh({
    Key? key,
    required this.onRefresh,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final layerDesign = DesignSystem.of(context);

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: child,
      strokeWidth: 2,
      color: layerDesign.brandPrimary,
      backgroundColor: layerDesign.surfaceOctonary1,
    );
  }
}
