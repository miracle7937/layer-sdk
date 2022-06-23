import 'package:flutter/material.dart';
import '../../../../layer_sdk.dart';

/// Creates the fullscreen loader for the dpa flow.
class DPAFullscreenLoader extends StatelessWidget {
  /// Creates a new [DPAFullscreenLoader].
  const DPAFullscreenLoader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final design = DesignSystem.of(context);

    return Container(
      // TODO: Add this color to the design system (modal/overlay)
      color: Color(0xFF191A19).withOpacity(0.64),
      child: Center(
        child: DKLoader(
          size: 72,
          startColor: design.basePrimaryWhite,
          endColor: design.basePrimaryWhite.withOpacity(0),
        ),
      ),
    );
  }
}
