import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'tutorial_step_item.dart';

/// Class that contains the data for a step for the [Tutorial]
class TutorialStep extends Equatable {
  /// The unique [GlobalKey] that identifies the step
  final GlobalKey? keyTarget;

  /// The position for this step
  ///
  /// It gets calculated using the keyTarget
  final Rect? targetPosition;

  /// The list of [TutorialStepItem] for this step
  final List<TutorialStepItem> contents;

  /// Creates a new [TutorialStep]
  TutorialStep({
    this.keyTarget,
    this.targetPosition,
    required this.contents,
  }) : assert(keyTarget != null || targetPosition != null);

  @override
  List<Object?> get props => [
        keyTarget,
        targetPosition,
        contents,
      ];
}
