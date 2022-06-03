import 'package:flutter/material.dart';
import '../../../../../../data_layer/data_layer.dart';

import '../../../../ui.dart';

/// Displays the image associated with this DPA process step, if any.
class DPAStepImage extends StatelessWidget {
  /// The DPA process that governs this widget.
  final DPAProcess process;

  /// The padding to use when there's an image to be displayed.
  ///
  /// Defaults to [EdgeInsets.zero].
  final EdgeInsets padding;

  /// The max height of the step image.
  ///
  /// Defaults to `142.0`
  final double maxHeight;

  /// The border radius of this [DPAStepImage].
  ///
  /// Defaults to `8.0`
  final double radius;

  /// Creates a new [DPAStepImage].
  const DPAStepImage({
    Key? key,
    required this.process,
    this.padding = EdgeInsets.zero,
    this.maxHeight = 142.0,
    this.radius = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (process.stepProperties?.image?.isEmpty ?? true) {
      return const SizedBox.shrink();
    }

    final image = ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: maxHeight,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: NetworkImageContainer(
          imageURL: process.stepProperties!.image!,
          fit: BoxFit.cover,
          customToken: EnvironmentConfiguration.current.defaultToken,
        ),
      ),
    );

    if (padding == EdgeInsets.zero) {
      return Align(
        alignment: AlignmentDirectional.topStart,
        child: image,
      );
    }

    return Align(
      alignment: AlignmentDirectional.topStart,
      child: Padding(
        padding: padding,
        child: image,
      ),
    );
  }
}
