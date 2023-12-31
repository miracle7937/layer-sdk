import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain_layer/models.dart';
import '../../../cubits.dart';
import '../../../utils.dart';
import '../../cubit_helpers/cubit_action_builder.dart';

/// Signature for [DPAContinueButton.builder].
///
/// The [processLabel] is an optional label sent by the DPA process.
typedef DPAContinueBuilder = Widget Function(
  BuildContext context,
  String? processLabel,
  bool enabled,
  bool busy,
  VoidCallback? onTap,
);

/// The default Layer Design Kit button that moves to the next step in the DPA
/// process when tapped.
class DPAContinueButton extends StatelessWidget {
  /// The DPA process that governs this widget.
  final DPAProcess process;

  /// An optional builder to create a continue button without caring about
  /// where we're getting the information for label or if it's enabled, or
  /// what to call when tapped.
  final DPAContinueBuilder? builder;

  /// Whether or not this button should be enabled.
  ///
  /// This is a way to disable the continue button from outside the cubits, use
  /// with caution.
  final bool enabled;

  /// Whether or not this button should be expanded
  /// to fit the parent horizontally.
  ///
  /// Defaults to true.
  final bool expands;

  /// A custom label to be shown instead of the process label and the default
  /// `continue` translation.
  final String? customLabel;

  /// A custom callback method to be called instead of stepping or finishing the
  /// current active process.
  final VoidCallback? customOnTap;

  /// Whether or not this button can change into a loading state
  /// This is useful when the DPA screen is
  /// composed by multiple [DPAContinueButton].
  ///
  /// Defaults to `true`.
  final bool canEnterLoadingState;

  /// Creates a new [DPAContinueButton].
  const DPAContinueButton({
    Key? key,
    required this.process,
    this.builder,
    this.enabled = true,
    this.expands = true,
    this.customLabel,
    this.customOnTap,
    this.canEnterLoadingState = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CubitActionBuilder<DPAProcessCubit, DPAProcessBusyAction>(
        actions: DPAProcessBusyAction.values.toSet(),
        builder: (context, loadingActions) {
          final translation = Translation.of(context);

          final cubit = context.watch<DPAProcessCubit>();

          final processLabel =
              customLabel ?? process.stepProperties?.confirmLabel;

          final effectiveEnabled = enabled &&
              cubit.state.activeProcess == process &&
              loadingActions.isEmpty &&
              !cubit.state.busyProcessingFile;

          final hasSkip =
              cubit.state.activeProcess.stepProperties?.skipButton ?? false;

          final onTap = effectiveEnabled
              ? (customOnTap ??
                  (hasSkip
                      ? () => cubit.stepOrFinish(
                            extraVariables: [
                              DPAVariable(
                                id: 'skip',
                                type: DPAVariableType.boolean,
                                property: DPAVariableProperty(),
                                value: false,
                              )
                            ],
                          )
                      : cubit.stepOrFinish))
              : null;

          final busy = canEnterLoadingState &&
              loadingActions.isNotEmpty &&
              cubit.state.activeProcess == process &&
              cubit.state.actions
                  .contains(DPAProcessBusyAction.steppingForward) &&
              (cubit.state.activeProcess.stepProperties?.skipLabel?.isEmpty ??
                  true);

          return builder?.call(
                context,
                processLabel,
                effectiveEnabled,
                busy,
                onTap,
              ) ??
              DKButton(
                title: processLabel ?? translation.translate('continue'),
                status: busy
                    ? DKButtonStatus.loading
                    : effectiveEnabled
                        ? DKButtonStatus.idle
                        : DKButtonStatus.disabled,
                onPressed: () => onTap?.call(),
                expands: expands,
              );
        });
  }
}
