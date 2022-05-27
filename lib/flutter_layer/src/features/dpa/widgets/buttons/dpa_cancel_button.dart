import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layer_sdk/business_layer/business_layer.dart';

import '../../../../resources.dart';

/// Signature for [DPACancelButton.builder].
typedef DPACancelBuilder = Widget Function(
  BuildContext context,
  bool busy,
  VoidCallback? onTap,
);

/// The default Layer Design Kit button that cancels the current DPA process
/// when tapped.
class DPACancelButton extends StatelessWidget {
  /// An optional builder to create the cancel button without caring about
  /// where we're getting the information for the busy state or what to call
  /// when tapped.
  final DPACancelBuilder? builder;

  /// A custom callback to the used instead of the default cancel process.
  ///
  /// Ignored if [builder] is provided.
  final VoidCallback? customOnTap;

  /// Whether or not this [DPACancelButton] is enabled.
  ///
  /// Defaults to `true`.
  final bool enabled;

  /// Creates a new [DPACancelButton].
  const DPACancelButton({
    Key? key,
    this.builder,
    this.customOnTap,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final layerDesign = DesignSystem.of(context);

    final busy = context.select<DPAProcessCubit, bool>(
      (cubit) => cubit.state.busy || cubit.state.busyProcessingFile,
    );

    final onTap = busy || !enabled
        ? () {}
        : (customOnTap ?? context.read<DPAProcessCubit>().cancelProcess);

    // TODO: add confirmation if LDK permits.
    return builder?.call(
          context,
          busy,
          onTap,
        ) ??
        DKButton.icon(
          onPressed: onTap,
          iconPath: FLImages.close,
          type: DKButtonType.basePlain,
          padding: EdgeInsets.zero,
          iconColor: layerDesign.baseQuaternary,
        );
  }
}
