import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../cubits.dart';
import '../../resources.dart';
import '../../utils.dart';
import '../../widgets.dart';
import '../../widgets/header/sdk_header.dart';
import '../../widgets/steps_indicator/sdk_steps_indicator.dart';

/// A screen that allows the user to enable or not the biometrics.
///
/// Usually used after a new user has been added.
class EnableBiometricsScreen extends StatefulWidget {
  /// Callback called when the user presses on the enable biometrics button.
  final VoidCallback onEnable;

  /// Callback called when the user presses on the skip button.
  final VoidCallback onSkip;

  /// The step information for showing the step indicator.
  /// If null, the step indicator will not show.
  final StepInfo? stepInfo;

  /// Creates a new [EnableBiometricsScreen].
  const EnableBiometricsScreen({
    Key? key,
    required this.onEnable,
    required this.onSkip,
    this.stepInfo,
  }) : super(key: key);

  @override
  State<EnableBiometricsScreen> createState() => _EnableBiometricsScreenState();
}

class _EnableBiometricsScreenState extends State<EnableBiometricsScreen> {
  @override
  void initState() {
    super.initState();
    _initializeBiometricsCubit();
  }

  Future<void> _initializeBiometricsCubit() async {
    final cubit = context.read<BiometricsCubit>();
    await cubit.initialize();

    if (!(cubit.state.canUseBiometrics ?? false) && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final layerDesign = DesignSystem.of(context);
    final translation = Translation.of(context);
    final busy = context.select<BiometricsCubit, bool>(
      (cubit) => cubit.state.busy,
    );

    return BlocListener<BiometricsCubit, BiometricsState>(
      listenWhen: (previous, current) =>
          previous.authenticated != current.authenticated &&
          current.authenticated != null,
      listener: (context, state) {
        if (state.authenticated!) {
          widget.onEnable();
        }
      },
      child: LayerScaffold(
        appBar: SDKHeader(
          title: translation.translate('enable_biometrics'),
          prefixSvgIcon: DKImages.arrowLeft,
          onPrefixIconPressed: () => Navigator.pop(context, false),
        ),
        body: busy
            ? Center(child: DKLoader())
            : Column(
                children: [
                  if (widget.stepInfo != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 18.0,
                      ),
                      child: SDKStepsIndicator(
                        currentStep: widget.stepInfo!.currentStep,
                        stepsCount: widget.stepInfo!.stepsCount,
                      ),
                    ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 32.0),
                      child: Column(
                        children: [
                          Spacer(),
                          SvgPicture.asset(
                            FLImages.biometrics,
                            height: 88.0,
                            width: 88.0,
                          ),
                          const SizedBox(height: 24.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 13.0),
                            child: Text(
                              translation
                                  .translate('enable_biometrics_description'),
                              style: layerDesign.bodyL(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Spacer(),
                          DKButton(
                            title: translation.translate('enable'),
                            onPressed: () => context
                                .read<BiometricsCubit>()
                                .authenticateInsecure(
                                  localizedReason: translation.translate(
                                    'biometric_dialog_description',
                                  ),
                                ),
                          ),
                          const SizedBox(height: 8.0),
                          DKButton(
                            title: translation.translate('skip'),
                            onPressed: widget.onSkip,
                            type: DKButtonType.baseSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// A model that represents the step info for the step indicator widget.
class StepInfo extends Equatable {
  /// The current step.
  final int currentStep;

  /// The total amount of steps.
  final int stepsCount;

  /// Creates a new [StepInfo].
  const StepInfo({
    required this.currentStep,
    required this.stepsCount,
  });

  @override
  List<Object?> get props => [
        currentStep,
        stepsCount,
      ];
}
