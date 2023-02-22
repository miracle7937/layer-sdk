import 'package:flutter/material.dart';

import '../../../../domain_layer/models.dart';
import '../../../widgets.dart';

/// A header for a DPA pop-up.
class DPAPopUpHeader extends StatelessWidget {
  /// The pop-up DPA process that governs this widget.
  final DPAProcess popup;

  /// An optional back button to be used in place of the default
  /// [DPABackButton].
  final Widget? customBackButton;

  /// An optional cancel button to be used in place of the default
  /// [DPACancelButton].
  final Widget? customCancelButton;

  /// If the back button should be shown.
  ///
  /// Defaults to `true`.
  final bool showBackButton;

  /// If the cancel button should be shown.
  ///
  /// Defaults to `false`.
  final bool showCancelButton;

  /// The vertical alignment for the items on the header.
  ///
  /// Defaults to [CrossAxisAlignment.center].
  final CrossAxisAlignment horizontalAlignment;

  /// The horizontal alignment for the center column with the icon, title and
  /// description.
  ///
  /// Defaults to [CrossAxisAlignment.center].
  final CrossAxisAlignment titleAlignment;

  /// Custom task description widget
  final DPAVariableListBuilder? customTaskDescription;

  /// Creates a new [DPAPopUpHeader].
  const DPAPopUpHeader({
    Key? key,
    required this.popup,
    this.customBackButton,
    this.customCancelButton,
    this.showBackButton = true,
    this.showCancelButton = false,
    this.customTaskDescription,
    this.horizontalAlignment = CrossAxisAlignment.center,
    this.titleAlignment = CrossAxisAlignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: use the new design kit.
    return Column(
      crossAxisAlignment: horizontalAlignment,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Opacity(
              opacity: showBackButton ? 1.0 : 0.0,
              child: showBackButton
                  ? customBackButton ??
                      const DPABackButton(
                        enabled: false,
                      )
                  : null,
            ),
            DPAStepImage(
              process: popup,
              padding: const EdgeInsets.only(bottom: 10.0),
              maxHeight: 24.0,
              radius: 0.0,
            ),
            Opacity(
              opacity: showCancelButton ? 1.0 : 0.0,
              child: showCancelButton
                  ? customCancelButton ??
                      const DPACancelButton(
                        enabled: false,
                      )
                  : null,
            ),
          ],
        ),
        DPATaskName(
          process: popup,
          padding: const EdgeInsets.only(bottom: 10.0),
        ),
        customTaskDescription?.call(context, popup) ??
            DPATaskDescription(process: popup)
      ],
    );
  }
}
