import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../layer_sdk.dart';
import '../../cubits.dart';

/// Signature for [DPAFlow.onFinished].
typedef DPAFinishedCallback<T> = void Function(
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
  LinkCubit linkCubit,
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

/// Signature for [DPAFlow.customCarouselScreenBuilder].
typedef DPACarouselScreenBuilder = Widget? Function(
  BuildContext context,
  DPAProcess process,
);

/// Signature for [DPAFlow.customErrorPresenter].
typedef DPAErrorPresenter = void Function({
  required BuildContext context,
  required String titleKey,
  String? message,
});

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

class DPAFlow<T> extends StatefulWidget {
  /// If it's during onboarding
  final bool isOnboarding;

  /// A required method to be called when the DPA process finishes.
  ///
  /// Use this to close the DPA window or do any other processing your app
  /// requires.
  final DPAFinishedCallback<T> onFinished;

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

  /// A custom builder to be used to create the second factor screen.
  final WidgetBuilder? customSecondFactorScreen;

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

  /// The custom empty search builder that will show when a search field
  /// input returned no results.
  ///
  /// If not indicated, a default one will show showing the translation
  /// assigned to the key `no_results_found`.
  ///
  /// This will only work if the [customChild] and [customVariableListBuilder]
  /// were not indicated. In that case, this should be handled there.
  final WidgetBuilder? customEmptySearchBuilder;

  /// Provide a custom padding for the continue button
  final EdgeInsets customContinueButtonPadding;

  /// The custom padding for the DPA screen content or the DPA variable list.
  final EdgeInsets? customContentPadding;

  /// Asset for logo
  final String? asset;

  /// Optional callback for creating custom Carousel Screens.
  final DPACarouselScreenBuilder? customCarouselScreemBuilder;

  /// Optional callback that allows to override the default bottom sheet error
  /// presenter.
  final DPAErrorPresenter? customErrorPresenter;

  /// Custom task description widget;
  final DPAVariableListBuilder? customTaskDescription;

  /// Custom effective continue button widget;
  final DPAVariableListBuilder? customEffectiveContinueButton;
  // TODO: it feels dumb having these here, consider a better solution
  /// The error to be displayed when the pin violates the maximum repetitive
  /// characters rule.
  final String maximumRepetitiveCharactersError;

  /// The error to be displayed when the pin violates the maximum sequential
  /// digits rule.
  final String maximumSequentialDigitsError;

  /// Creates a new [DPAFlow].
  const DPAFlow({
    Key? key,
    required this.onFinished,
    this.customSecondFactorScreen,
    this.customHeader,
    this.customVariableListBuilder,
    this.customContinueButton,
    this.customChild,
    this.customShowPopUp,
    this.customHidePopUp,
    this.showTaskDescription = true,
    this.customEmptySearchBuilder,
    required this.sdkCallback,
    this.isOnboarding = false,
    this.asset,
    this.customContinueButtonPadding = const EdgeInsets.fromLTRB(
      16.0,
      0.0,
      16.0,
      42.0,
    ),
    this.customContentPadding,
    this.customCarouselScreemBuilder,
    this.customErrorPresenter,
    this.customTaskDescription,
    this.customEffectiveContinueButton,
    required this.maximumRepetitiveCharactersError,
    required this.maximumSequentialDigitsError,
  }) : super(key: key);

  @override
  State<DPAFlow<T>> createState() => _DPAFlowState<T>();
}

class _DPAFlowState<T> extends State<DPAFlow<T>> {
  /// Whether if a error is showing or not;
  var _isErrorShowing = false;

  @override
  Widget build(BuildContext context) {
    final process = context.select<DPAProcessCubit, DPAProcess>(
      (cubit) => cubit.state.process,
    );

    final hasPopup = context.select<DPAProcessCubit, bool>(
      (cubit) => cubit.state.hasPopup,
    );

    final areVariablesValidated = context.select<DPAProcessCubit, bool>(
      (cubit) => cubit.state.areVariablesValidated,
    );

    final actions = context.select<DPAProcessCubit, Set<DPAProcessBusyAction>>(
      (c) => c.state.actions,
    );

    final translation = Translation.of(context);
    final cubit = context.read<DPAProcessCubit>();
    final isDelayTask = process.stepProperties?.delay != null;

    final hasJumioConfig = process.stepProperties?.jumioConfig != null;

    final effectiveContinueButton = widget.customEffectiveContinueButton != null
        ? (widget.customEffectiveContinueButton!(context, process))
        : ((process.variables.length == 1 &&
                    process.variables.first.property.searchBar) ||
                hasJumioConfig
            ? null
            : widget.customContinueButton ??
                DPAContinueButton(
                  process: process,
                  enabled: !hasPopup && areVariablesValidated,
                ));

    final effectiveHeader = (process.stepProperties?.hideAppBar ?? false)
        ? null
        : widget.customHeader ?? DPAHeader(process: process);

    final shouldShowSkipButton =
        process.stepProperties?.skipLabel?.isNotEmpty ?? false;

    return MultiBlocListener(
        listeners: [
          BlocListener<DPAProcessCubit, DPAProcessState>(
            listenWhen: (oldState, newState) =>
                oldState.process.stepProperties?.jumioConfig !=
                    newState.process.stepProperties?.jumioConfig &&
                newState.process.stepProperties?.jumioConfig != null,
            listener: (context, state) {
              final dpaProcessCubit = context.read<DPAProcessCubit>();
              widget.sdkCallback(context, dpaProcessCubit, state.process);
            },
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
          BlocListener<DPAProcessCubit, DPAProcessState>(
            listenWhen: (oldState, newState) =>
                oldState.runStatus != newState.runStatus &&
                newState.runStatus == DPAProcessRunStatus.finished,
            listener: widget.onFinished,
          ),
        ],
        child: CubitErrorListener<DPAProcessCubit, DPAProcessBusyAction>(
          actions: DPAProcessBusyAction.values.toSet(),
          onConnectivityError: (error) =>
              _showConnectivityError(context, error: error),
          onAPIError: (error) => _showAPIError(context, error: error),
          child: Stack(
            children: [
              _getEffectiveCustomChild(context) ??
                  // TODO: update to use the correct Layer Design Kit design.
                  // TODO: update to handle the different pages
                  Column(
                    children: [
                      if (effectiveHeader != null) effectiveHeader,
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              if (widget.showTaskDescription)
                                widget.customTaskDescription
                                        ?.call(context, process) ??
                                    DPATaskDescription(
                                      process: process,
                                      showTitle: effectiveHeader == null,
                                    ),
                              Padding(
                                padding: widget.customContentPadding ??
                                    const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                child: widget.customVariableListBuilder?.call(
                                      context,
                                      process,
                                    ) ??
                                    DPAVariablesList(
                                      process: process,
                                      customEmptySearchBuilder:
                                          widget.customEmptySearchBuilder,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: widget.customContinueButtonPadding,
                        child: Column(
                          children: [
                            if (effectiveContinueButton != null)
                              effectiveContinueButton,
                            if (shouldShowSkipButton) ...[
                              const SizedBox(height: 12.0),
                              DPASkipButton(
                                process: process,
                              ),
                            ],
                            if (process.stepProperties?.skipButton ??
                                false) ...[
                              const SizedBox(
                                height: 12.0,
                              ),
                              DPACancelButton(
                                builder: (context, _, __) => DKButton(
                                  size: DKButtonSize.large,
                                  title:
                                      process.stepProperties?.skipButtonLabel ??
                                          translation.translate('cancel'),
                                  onPressed: () => cubit.skipOrFinish(
                                    extraVariables: [
                                      DPAVariable(
                                        id: 'skip',
                                        type: DPAVariableType.boolean,
                                        property: DPAVariableProperty(),
                                        value: true,
                                      )
                                    ],
                                  ),
                                  status: actions.contains(
                                    DPAProcessBusyAction.skipping,
                                  )
                                      ? DKButtonStatus.loading
                                      : DKButtonStatus.idle,
                                  type: DKButtonType.baseSecondary,
                                  expands: true,
                                ),
                              )
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
              if (isDelayTask) DPAFullscreenLoader(asset: widget.asset),
            ],
          ),
        ));
  }

  /// Shows the transfer error bottom sheet.
  Future<void> _showErrorBottomSheet({
    required String titleKey,
    String? descriptionKey,
  }) async {
    if (!_isErrorShowing) {
      _isErrorShowing = true;

      await BottomSheetHelper.showError(
        context: context,
        titleKey: titleKey,
        descriptionKey: descriptionKey,
        dismissKey: 'done',
        blurBackground: true,
      );

      _isErrorShowing = false;
    }
  }

  /// Called when a new connectivity error is emitted by the cubit.
  void _showConnectivityError(
    BuildContext context, {
    required CubitConnectivityError<DPAProcessBusyAction> error,
  }) {
    if (widget.customErrorPresenter != null) {
      widget.customErrorPresenter!(
        context: context,
        titleKey: 'connectivity_error',
      );
    } else {
      _showErrorBottomSheet(
        titleKey: 'connectivity_error',
      );
    }
  }

  /// Called when a new api error is emitted by the cubit.
  void _showAPIError(
    BuildContext context, {
    required CubitAPIError<DPAProcessBusyAction> error,
  }) {
    if (widget.customErrorPresenter != null) {
      widget.customErrorPresenter!(
        context: context,
        titleKey: error.code?.value ?? 'generic_error',
        message: error.message,
      );
    } else {
      _showErrorBottomSheet(
        titleKey: error.code?.value ?? 'generic_error',
        descriptionKey: error.message,
      );
    }
  }

  Widget? _getEffectiveCustomChild(BuildContext context) {
    if (widget.customChild != null) {
      return widget.customChild;
    }

    final process = context.select<DPAProcessCubit, DPAProcess>(
      (cubit) => cubit.state.process,
    );

    final isCarouselScreen = process.variables.isNotEmpty &&
        process.variables.every(
          (e) => e.type == DPAVariableType.swipe,
        );
    if (isCarouselScreen) {
      return widget.customCarouselScreemBuilder?.call(context, process) ??
          DPACarouselScreen();
    }

    final isOTPScreen =
        process.stepProperties?.screenType == DPAScreenType.otp ||
            process.stepProperties?.screenType == DPAScreenType.secondFactor;
    if (isOTPScreen) {
      return widget.customSecondFactorScreen?.call(context) ??
          DPAOTPScreen(
            isOnboarding: widget.isOnboarding,
            customDPAHeader: widget.customHeader,
          );
    }

    final isEmailValidationScreen =
        process.stepProperties?.screenType == DPAScreenType.email;
    if (isEmailValidationScreen) {
      return DPAEmailVerificationScreen(
        customDPAHeader: widget.customHeader,
      );
    }

    final pinVariable = process.variables
        .singleWhereOrNull((variable) => variable.type == DPAVariableType.pin);

    final effectiveHeader = (process.stepProperties?.hideAppBar ?? false)
        ? null
        : widget.customHeader ?? DPAHeader(process: process);

    if (pinVariable != null) {
      return BlocProvider<AccessPinValidationCubit>(
        create: (context) =>
            context.read<AccessPinValidationCreator>().create(),
        child: DPASetAccessPin(
          header: effectiveHeader,
          maximumRepetitiveCharactersError:
              widget.maximumRepetitiveCharactersError,
          maximumSequentialDigitsError: widget.maximumSequentialDigitsError,
          dpaVariable: pinVariable.copyWith(
            label: process.task?.description,
          ),
          onAccessPinSet: (pin) {
            final cubit = context.read<DPAProcessCubit>();
            cubit.updateValue(
              variable: pinVariable,
              newValue: pin,
            );
            cubit.stepOrFinish();
          },
        ),
      );
    }

    final isStepWaitingForEmail =
        process.stepProperties?.screenType == DPAScreenType.waitingEmail;

    if (isStepWaitingForEmail) {
      return DPAWaitingEmailScreen(
        process: process,
      );
    }

    return null;
  }

  void _hidePopUp(BuildContext context, DPAProcessState state) {
    if (widget.customHidePopUp != null) {
      widget.customHidePopUp!.call(
        context,
        context.read<DPAProcessCubit>(),
      );

      return;
    }

    Navigator.of(context).pop();
  }

  void _showPopUp(BuildContext context, DPAProcessState state) {
    final processCubit = context.read<DPAProcessCubit>();
    final linkCubit = context.read<LinkCubit>();

    if (widget.customShowPopUp != null) {
      widget.customShowPopUp!.call(
        context,
        processCubit,
        linkCubit,
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
          customVariableListBuilder: widget.customVariableListBuilder,
          customContinueButton: widget.customContinueButton,
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

    final shouldShowSkipButton =
        popUp?.stepProperties?.skipLabel?.isNotEmpty ?? false;

    if (popUp == null) return const SizedBox.shrink();
    final areVariablesValidated = context.select<DPAProcessCubit, bool>(
      (cubit) => cubit.state.areVariablesValidated,
    );
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
              enabled: areVariablesValidated,
            ),
        if (shouldShowSkipButton) ...[
          const SizedBox(height: 12.0),
          DPASkipButton(
            process: popUp,
          ),
        ],
      ],
    );
  }
}
