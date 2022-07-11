import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain_layer/models.dart';
import '../../../cubits.dart';
import '../../../utils.dart';

/// The default Layer Design Kit button that skips the current steps and moves
/// to the next step in the DPA process when tapped.
class DPASkipButton extends StatelessWidget {
  /// The DPA process that governs this widget.
  final DPAProcess process;

  /// Creates a new [DPASkipButton].
  const DPASkipButton({
    Key? key,
    required this.process,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final translation = Translation.of(context);

    final cubit = context.watch<DPAProcessCubit>();

    final processLabel = process.stepProperties?.skipLabel;

    final busy = cubit.state.busy &&
        cubit.state.activeProcess == process &&
        cubit.state.actions.contains(DPAProcessBusyAction.steppingForward) &&
        (cubit.state.activeProcess.stepProperties?.skipLabel?.isNotEmpty ??
            false);

    return DKButton(
      title: processLabel ?? translation.translate('skip'),
      type: DKButtonType.baseSecondary,
      status: busy ? DKButtonStatus.loading : DKButtonStatus.idle,
      onPressed: cubit.stepOrFinish,
    );
  }
}
