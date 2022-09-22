import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';

/// A mixin that allows to show a fullscreen loader.
mixin FullScreenLoaderMixin {
  /// Shows a loader dialog.
  ///
  /// Needs to be popped manually.
  Future<void> showFullScreenLoader(BuildContext context) {
    final design = DesignSystem.of(context);

    return showDialog(
      context: context,
      useSafeArea: false,
      barrierDismissible: false,
      barrierColor: design.basePrimary.withOpacity(0.64),
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: DKLoader(
            size: 72,
            startColor: design.basePrimaryWhite,
            endColor: design.basePrimaryWhite.withOpacity(0),
          ),
        ),
      ),
    );
  }
}
