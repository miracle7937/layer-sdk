import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../widgets.dart';

/// Mixin that exposes common methods for the tutorial feature.
mixin TutorialMixin {
  /// Gets the current target position for a [TutorialStep] target.
  Rect? getStepTargetPosition(TutorialStep step) {
    final _log = Logger('TutorialUtils');

    if (step.keyTarget != null) {
      var key = step.keyTarget!;

      try {
        final renderBoxRed =
            key.currentContext!.findRenderObject() as RenderBox;
        final size = renderBoxRed.size;
        final state =
            key.currentContext!.findAncestorStateOfType<NavigatorState>();
        Offset offset;
        if (state != null) {
          offset = renderBoxRed.localToGlobal(Offset.zero,
              ancestor: state.context.findRenderObject());
        } else {
          offset = renderBoxRed.localToGlobal(Offset.zero);
        }

        return offset & size;
      } on Exception catch (e) {
        _log.severe(e);

        return null;
      }
    } else {
      return step.targetPosition;
    }
  }
}
