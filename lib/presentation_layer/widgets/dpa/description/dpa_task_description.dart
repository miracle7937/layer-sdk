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

  /// Creates a new [DPATaskDescription] instance.
  const DPATaskDescription({
    Key? key,
    required this.process,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final design = DesignSystem.of(context);

    final taskDescription = process.task?.description;
    final stepImage = process.stepProperties?.image;

    if (taskDescription == null && stepImage == null) {
      return SizedBox.shrink();
    }

    final alignment = process.stepProperties?.alignment ??
        DPAScreenAlignment.imageDescription;

    final description = taskDescription == null
        ? SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Text(
              taskDescription,
              style: design.bodyM(),
              textAlign: alignment == DPAScreenAlignment.imageDescription
                  ? TextAlign.left
                  : TextAlign.center,
            ),
          );

    final image = stepImage == null
        ? SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: NetworkImageContainer(
              imageURL: stepImage,
              customToken: EnvironmentConfiguration.current.defaultToken,
            ),
          );

    return Column(
      children: [
        alignment == DPAScreenAlignment.imageDescription ? image : description,
        alignment == DPAScreenAlignment.imageDescription ? description : image,
      ],
    );
  }
}
