import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain_layer/models.dart';
import '../../cubits.dart';
import '../../widgets.dart';

/// Signature for [DPAFlow.onError].
typedef DPAErrorCallback = void Function(
  BuildContext context,
  DPAProcessErrorStatus errorStatus,
);

/// Signature for [DPAFlow.onFinished].
typedef DPAFinishedCallback = void Function(
  BuildContext context,
  DPAProcessState state,
);

/// Signature for [DPAFlow.customVariableListBuilder].
typedef DPAVariableListBuilder = Widget? Function(
  BuildContext context,
  DPAProcess process,
);

/// Signature for [DPAFlow.customShowPopUp].
typedef DPAShowPopUpCallback = void Function(
  BuildContext context,
  DPAProcessCubit cubit,
  DPAProcess popUp,
);

/// Signature for [DPAFlow.startSDK].
typedef DPAStartSDKCallback = void Function(
  BuildContext context,
  DPAProcessCubit cubit,
  DPAProcess process,
);

/// Signature for [DPAFlow.customHidePopUp].
typedef DPAHidePopUpCallback = void Function(
  BuildContext context,
  DPAProcessCubit cubit,
);

/// A widget that starts a flow that has been created by a user console.
///
/// By default this widget uses the design kit layer widgets but it exposes
/// multiple parameters for the componentes to be customized if needed.
///
/// The [onError] callback is required and allows you to get the
/// [DPAProcessErrorStatus] whenever an error happens.
///
/// The [onFinished] callback is also required an will notify you back when
/// the dpa flow is finished. The [DPAProcessState] will be returned.
///
/// Customizable widgets:
///
///   * [customHeader]. Custom widget to be used as the header. By default,
///   the [DPAHeader] will be used.
///
///   * [customVariableListBuilder]. Custom builder for creating the variable
///   list from the current dpa flow step. By default the [DPAVariablesList]
///   will be used. In case the requested process widget is not returned
///   through the [customVariableListBuilder], the default [DPAVariablesList]
///   widget implementation for the process will be used.
///
///   * [customContinueButton]. Custom widget to be used as the continue
///   to next dpa flow step button. By default the [DPAContinueButton] will
///   be used.
///
/// The parameters above will be overriden if the following custom parameters
/// are passed:
///
///   * [customChild]. Custom widget that, if passed, will override all the
///   dpa flow default widgets. You will have to take care of all the widgets
///   that might appear on a dpa flow. The use of this widget is not
///   recomended. This widget will override the [customHeader],
///   [customVariableListBuilder] and [customContinueButton] parameters.
///
///   * [customShowPopUp]. Custom callback to show a dpa flow step of type
///   popup. This widget will override the [customVariableListBuilder] used
///   in the default popups.
///
/// An optional [customHidePopUp] parameter can be passed as a custom callback
/// for hidding popups. By default, the [Navigator.pop] method will be
/// called.
///
/// {@tool snippet}
///
/// This widget depends on the [DPAProcessCubit], usually the
/// [DPAProcessCubit.start] with the desired dpa flow key is called on the same
/// view that this widget gets implemented on:
///
/// ```dart
///
/// bool initialized = false;
///
/// @override
/// void didChangeDependencies(){
///   if(!initialized){
///     initialized = true;
///
///     context.read<DPAProcessCubit>().start(
///       definitionId: 'onboarding',
///       variables: <DPAVariable>[],
///     );
///   }
/// }
///
/// DPAFlow(
///   onError: (context, errorStatus){
///     //Handle the error status.
///   },
///   onFinished: (context, state){
///     //Handle the state.
///   },
/// );
/// ```
/// {@end-tool}
class DPAFlow extends StatelessWidget {
  /// A required method to be called when an error occurs.
  ///
  /// This is not the same as errors on a variable (mostly from validations).
  /// These errors are treated when building the variable on the
  /// [DPAVariablesList].
  ///
  /// The error here is a more encompassing error, like a network error when
  /// trying to update the DPA process.
  final DPAErrorCallback onError;

  /// A required method to be called when the DPA process finishes.
  ///
  /// Use this to close the DPA window or do any other processing your app
  /// requires.
  final DPAFinishedCallback onFinished;

  /// A custom widget to be used as the header.
  ///
  /// Preferably, you'll use a custom [DPAHeader], but it's not required.
  ///
  /// Ignored if a [customChild] is provided.
  final Widget? customHeader;

  /// A custom builder to be used to create the variables list.
  ///
  /// Ignored if both [customChild] and [customShowPopUp] are provided.
  final DPAVariableListBuilder? customVariableListBuilder;

  /// A custom widget to be used as the continue to next step button.
  ///
  /// Preferably, you'll use a custom [DPAContinueButton], but it's not
  /// required.
  ///
  /// Ignored if a [customChild] is provided.
  final Widget? customContinueButton;

  /// An optional widget to be used in place of the screen. This should take
  /// care of all the variables lists and different page states, and its use is
  /// not recommended.
  ///
  /// When this is set, only the [onError] and [onFinished] callbacks are still
  /// used on this widget.
  final Widget? customChild;

  /// An optional callback to show the pop-up.
  ///
  /// If null, the default Design Kit pop-up is used.
  ///
  /// If creating a new page or dialog, do not forget to provide the given
  /// cubit to the new tree.
  final DPAShowPopUpCallback? customShowPopUp;

  /// An optional callback to hide the pop-up.
  ///
  /// If null, the default navigator.pop is called.
  final DPAHidePopUpCallback? customHidePopUp;

  /// Whether or not the current task description/image should be shown
  ///
  /// Defaults to `true`.
  final bool showTaskDescription;

  /// The callback called when the dpa step needs to launch an sdk.
  final DPAStartSDKCallback sdkCallback;

  /// Creates a new [DPAFlow].
  const DPAFlow({
    Key? key,
    required this.onError,
    required this.onFinished,
    this.customHeader,
    this.customVariableListBuilder,
    this.customContinueButton,
    this.customChild,
    this.customShowPopUp,
    this.customHidePopUp,
    this.showTaskDescription = true,
    required this.sdkCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final process = context.select<DPAProcessCubit, DPAProcess>(
      (cubit) => cubit.state.process,
    );

    final hasPopup = context.select<DPAProcessCubit, bool>(
      (cubit) => cubit.state.hasPopup,
    );

    final isCarouselScreen = process.variables.isNotEmpty &&
        process.variables.every(
          (e) => e.type == DPAVariableType.swipe,
        );

    final isOTPScreen = process.stepProperties?.screenType == DPAScreenType.otp;

    final isEmailValidationScreen =
        process.stepProperties?.screenType == DPAScreenType.email;

    final effectiveCustomChild = isCarouselScreen
        ? DPACarouselScreen()
        : isOTPScreen
            ? DPAOTPScreen(
                customDPAHeader: customHeader,
              )
            : isEmailValidationScreen
                ? DPAEmailScreen(
                    customDPAHeader: customHeader,
                  )
                : customChild;

    final isDelayTask = process.stepProperties?.delay != null;

    final effectiveContinueButton = process.variables.length == 1 &&
            process.variables.first.property.searchBar
        ? null
        : customContinueButton ??
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16.0,
                0.0,
                16.0,
                42.0,
              ),
              child: DPAContinueButton(
                process: process,
                enabled: !hasPopup,
              ),
            );

    final effectiveHeader = (process.stepProperties?.hideAppBar ?? false)
        ? null
        : customHeader ?? DPAHeader(process: process);

    return MultiBlocListener(
      listeners: [
        BlocListener<DPAProcessCubit, DPAProcessState>(
          listenWhen: (oldState, newState) =>
              oldState.errorStatus != newState.errorStatus &&
              newState.errorStatus != DPAProcessErrorStatus.none,
          // TODO: see if we can have a default LDK error.
          listener: (context, state) => onError(context, state.errorStatus),
        ),
        BlocListener<DPAProcessCubit, DPAProcessState>(
          listenWhen: (oldState, newState) =>
              oldState.process.stepProperties?.jumioConfig !=
                  newState.process.stepProperties?.jumioConfig &&
              newState.process.stepProperties?.jumioConfig != null,
          listener: (context, state) {
            final dpaProcessCubit = context.read<DPAProcessCubit>();
            sdkCallback(context, dpaProcessCubit, state.process);
          },
        ),
        BlocListener<DPAProcessCubit, DPAProcessState>(
          listenWhen: (oldState, newState) =>
              oldState.runStatus != newState.runStatus &&
              newState.runStatus == DPAProcessRunStatus.finished,
          listener: onFinished,
        ),
        BlocListener<DPAProcessCubit, DPAProcessState>(
          listenWhen: (oldState, newState) =>
              oldState.popUp != null && newState.popUp == null,
          listener: _hidePopUp,
        ),
        BlocListener<DPAProcessCubit, DPAProcessState>(
          listenWhen: (oldState, newState) =>
              oldState.popUp == null && newState.popUp != null,
          listener: _showPopUp,
        ),
      ],
      child: Stack(
        children: [
          effectiveCustomChild ??
              // TODO: update to use the correct Layer Design Kit design.
              // TODO: update to handle the different pages
              Column(
                children: [
                  if (effectiveHeader != null) effectiveHeader,
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (showTaskDescription)
                            DPATaskDescription(
                              process: process,
                              showTitle: effectiveHeader == null,
                            ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: customVariableListBuilder?.call(
                                  context,
                                  process,
                                ) ??
                                DPAVariablesList(process: process),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (effectiveContinueButton != null) effectiveContinueButton,
                ],
              ),
          if (isDelayTask) DPAFullscreenLoader(),
        ],
      ),
    );
  }

  void _hidePopUp(BuildContext context, DPAProcessState state) {
    if (customHidePopUp != null) {
      customHidePopUp!.call(
        context,
        context.read<DPAProcessCubit>(),
      );

      return;
    }

    Navigator.of(context).pop();
  }

  void _showPopUp(BuildContext context, DPAProcessState state) {
    final processCubit = context.read<DPAProcessCubit>();

    if (customShowPopUp != null) {
      customShowPopUp!.call(
        context,
        processCubit,
        processCubit.state.popUp!,
      );

      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BlocProvider.value(
        value: processCubit,
        child: _PopUpContents(
          customVariableListBuilder: customVariableListBuilder,
          customContinueButton: customContinueButton,
        ),
      ),
    );
  }
}

class _PopUpContents extends StatelessWidget {
  final DPAVariableListBuilder? customVariableListBuilder;

  final Widget? customContinueButton;

  const _PopUpContents({
    Key? key,
    this.customVariableListBuilder,
    this.customContinueButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final popUp = context.select<DPAProcessCubit, DPAProcess?>(
      (c) => c.state.popUp,
    );

    if (popUp == null) return const SizedBox.shrink();

    // TODO: update to use the correct Layer Design Kit design.
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DPAPopUpHeader(popup: popUp),
        customVariableListBuilder?.call(
              context,
              popUp,
            ) ??
            DPAVariablesList(
              process: popUp,
            ),
        customContinueButton ??
            DPAContinueButton(
              process: popUp,
            ),
      ],
    );
  }
}
