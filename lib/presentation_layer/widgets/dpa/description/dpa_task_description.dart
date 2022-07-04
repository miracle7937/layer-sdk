import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';

import '../../../../data_layer/environment.dart';
import '../../../../features/dpa.dart';
import '../../../widgets.dart';

/// Widget that displays the current process image and description by checking
/// the alignment and setting up the widgets accordingly
class DPATaskDescription extends StatelessWidget {
  /// The current [DPAProcess].
  final DPAProcess process;

  /// Whether or not the name of the current task should be shown with the
  /// description.
  ///
  /// Defaults to `false`.
  final bool showTitle;

  /// Creates a new [DPATaskDescription] instance.
  const DPATaskDescription({
    Key? key,
    required this.process,
    this.showTitle = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskDescription = process.task?.description;
    final stepImage = process.stepProperties?.image;

    if (taskDescription == null && stepImage == null) {
      return SizedBox.shrink();
    }

    final alignment = process.stepProperties?.alignment ??
        DPAScreenAlignment.imageDescription;

    final description = taskDescription?.isEmpty ?? true
        ? SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: _DPATaskTitleDescriptionWidget(
              title: showTitle ? process.task?.name : null,
              description: taskDescription!,
              align: alignment == DPAScreenAlignment.imageDescription
                  ? TextAlign.left
                  : TextAlign.center,
            ),
          );

    final image = stepImage?.isEmpty ?? true
        ? SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: NetworkImageContainer(
              imageURL: stepImage!,
              customToken: EnvironmentConfiguration.current.defaultToken,
            ),
          );

    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          alignment == DPAScreenAlignment.imageDescription
              ? image
              : description,
          alignment == DPAScreenAlignment.imageDescription
              ? description
              : image,
        ],
      ),
    );
  }
}

class _DPATaskTitleDescriptionWidget extends StatelessWidget {
  final String? title;
  final String description;
  final TextAlign align;

  const _DPATaskTitleDescriptionWidget({
    Key? key,
    required this.description,
    required this.align,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final design = DesignSystem.of(context);

    return Column(
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: design.titleXL(),
            textAlign: align,
          ),
          const SizedBox(height: 16.0),
        ],
        Text(
          description,
          style: design.bodyM(),
          textAlign: align,
        ),
      ],
    );
  }
}
