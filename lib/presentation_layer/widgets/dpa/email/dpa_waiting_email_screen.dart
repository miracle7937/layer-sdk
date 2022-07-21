import 'package:flutter/material.dart';

import '../../../../data_layer/environment.dart';
import '../../../../layer_sdk.dart';

/// A DPA screen that shows when a step is waiting an email link to be pressed.
class DPAWaitingEmailScreen extends StatelessWidget {
  /// The dpa process.
  final DPAProcess process;

  /// Creates a new [DPAWaitingEmailScreen].
  const DPAWaitingEmailScreen({
    Key? key,
    required this.process,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final layerDesign = DesignSystem.of(context);

    final image = process.stepProperties?.image;
    final label = process.task?.name;
    final description = process.task?.description;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 32.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (image != null) ...[
              NetworkImageContainer(
                imageURL: image,
                customToken: EnvironmentConfiguration.current.defaultToken,
              ),
              const SizedBox(height: 23.0),
            ],
            if (label != null)
              Text(
                label,
                style: layerDesign.titleXL(),
                textAlign: TextAlign.center,
              ),
            if (label != null && description != null)
              const SizedBox(height: 16.0),
            if (description != null)
              Text(
                description,
                style: layerDesign.bodyM(),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
