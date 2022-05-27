import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../tutorial_controller.dart';

/// The item alignment
enum TutorialItemAlignment {
  /// Aligned to the top of the target position
  top,

  /// Aligned to the bottom of the target position
  bottom,

  /// Aligned to the left of the target position
  left,

  /// Aligned to the right of the target position
  right,

  /// Aligned at the center of the screen
  center,

  /// The item will overlap the target position
  overlap,

  /// The item will be pinned at the start of the screen
  pinned,
}

/// Custom builder in case the [TutorialStepItem] child needs to access
/// the [BuildContext] or the [TutorialController]
///
/// The child is the item that will be highlighted and not obstructed by
/// the tutorial back shadow.
///
/// This can be handy for accesing inherited resources as Localizations.
typedef TutorialStepItemBuilder = Widget Function(
  BuildContext context,
  TutorialController controller,
);

/// Class that represents an item for a [TutorialStep]
class TutorialStepItem extends Equatable {
  /// The alignment for this item relative to
  /// the [TutorialStep.targetPosition]
  final TutorialItemAlignment alignment;

  /// The padding for this item
  final EdgeInsets padding;

  /// The child for this item
  final Widget? child;

  /// The builder in case this item needs the context or the controller
  /// for its creation
  final TutorialStepItemBuilder? builder;

  /// Creates a new [TutorialStepItem]
  TutorialStepItem({
    this.alignment = TutorialItemAlignment.bottom,
    this.padding = const EdgeInsets.all(20.0),
    this.child,
    this.builder,
  });

  @override
  List<Object?> get props => [
        alignment,
        padding,
        child,
        builder,
      ];
}
