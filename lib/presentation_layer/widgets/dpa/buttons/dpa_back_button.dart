import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubits.dart';
import '../../../resources.dart';
import '../../../utils.dart';

/// Signature for [DPABackButton.builder].
typedef DPABackBuilder = Widget Function(
  BuildContext context,
  bool canGoBack,
  bool busy,
  VoidCallback? onTap,
);

/// Type of this DPA Back button.
enum DPABackButtonType {
  /// Header back button type.
  header,

  /// Button type.
  button,
}

/// The default Layer Design Kit button that moves to a previous step in the DPA
/// process when tapped.
class DPABackButton extends StatelessWidget {
  /// An optional builder to create the back button without caring about
  /// where we're getting the information of when can go back or what to call
  /// when tapped.
  final DPABackBuilder? builder;

  /// The duration for the show/hide animation for the button.
  ///
  /// Defaults to 200 milliseconds.
  final Duration duration;

  /// The type of this button.
  final DPABackButtonType type;

  /// If true, the button expands to fill the available space
  ///
  /// Defaults to `true`.
  final bool expands;

  /// Whether or not this back button is enabled.
  ///
  /// Defaults to `true`.
  final bool enabled;

  /// Creates a new [DPABackButton].
  const DPABackButton({
    Key? key,
    this.builder,
    this.duration = const Duration(milliseconds: 200),
    this.type = DPABackButtonType.header,
    this.expands = true,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final canGoBack = context.select<DPAProcessCubit, bool>(
      (cubit) =>
          !cubit.state.busy &&
          !cubit.state.busyProcessingFile &&
          cubit.state.activeProcess.canGoBack,
    );

    final cubitBusy = context.select<DPAProcessCubit, bool>(
      (cubit) => cubit.state.busy || cubit.state.busyProcessingFile,
    );

    final buttonLoading = context.select<DPAProcessCubit, bool>(
      (cubit) => cubit.state.actions.any(
        (action) => [
          DPAProcessBusyAction.steppingBack,
          DPAProcessBusyAction.cancelling,
        ].contains(action),
      ),
    );

    final onTap = (cubitBusy || !canGoBack || !enabled)
        ? () {}
        : context.read<DPAProcessCubit>().stepBack;

    switch (type) {
      case DPABackButtonType.header:
        return _DPAHeaderBackButton(
          canGoBack: canGoBack,
          busy: buttonLoading,
          duration: duration,
          builder: builder,
          onTap: onTap,
        );

      case DPABackButtonType.button:
        return _DPABackButton(
          canGoBack: canGoBack,
          busy: buttonLoading,
          builder: builder,
          onTap: onTap,
          expands: expands,
        );
    }
  }
}

class _DPAHeaderBackButton extends StatelessWidget {
  final bool canGoBack;
  final bool busy;
  final Duration duration;
  final DPABackBuilder? builder;
  final Future<void>? Function() onTap;

  const _DPAHeaderBackButton({
    Key? key,
    required this.canGoBack,
    required this.busy,
    required this.duration,
    required this.builder,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final layerDesign = DesignSystem.of(context);

    return Column(
      children: [
        AnimatedOpacity(
          opacity: canGoBack ? 1.0 : 0.0,
          duration: duration,
          child: builder?.call(
                context,
                canGoBack,
                busy,
                onTap,
              ) ??
              DKButton.icon(
                onPressed: onTap,
                iconPath: FLImages.back,
                type: DKButtonType.basePlain,
                padding: EdgeInsets.zero,
                iconColor: layerDesign.baseQuaternary,
                expands: false,
              ),
        ),
      ],
    );
  }
}

class _DPABackButton extends StatelessWidget {
  final bool canGoBack;
  final bool busy;
  final bool expands;
  final DPABackBuilder? builder;
  final Future<void>? Function() onTap;

  const _DPABackButton({
    Key? key,
    required this.canGoBack,
    required this.busy,
    required this.builder,
    required this.onTap,
    required this.expands,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final layerDesign = DesignSystem.of(context);
    final translation = Translation.of(context);

    return builder?.call(
          context,
          canGoBack,
          busy,
          onTap,
        ) ??
        DKButton(
          title: translation.translate('back'),
          onPressed: onTap,
          type: DKButtonType.baseSecondary,
          iconColor: layerDesign.baseQuaternary,
          status: busy
              ? DKButtonStatus.loading
              : canGoBack
                  ? DKButtonStatus.idle
                  : DKButtonStatus.disabled,
          expands: expands,
        );
  }
}
