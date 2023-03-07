import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/user.dart';
import '../../creators.dart';
import '../../cubits.dart';
import '../../features.dart';
import '../../utils.dart';
import '../../widgets.dart';

/// A screen that allows the user to set an access pin.
class SetAccessPinScreen extends SetAccessPinBaseWidget {
  /// The app bar for the set pin screen.
  final PreferredSizeWidget? setPinAppBar;

  /// The app bar for the repeat pin screen.
  final PreferredSizeWidget? repeatPinAppBar;

  /// The title for the set pin screen.
  final String setPinTitle;

  /// The title for the repeat pin screen.
  final String repeatPinTitle;

  /// The error to be displayed when the pin violates the maximum repetitive
  /// characters rule.
  final String maximumRepetitiveCharactersError;

  /// The error to be displayed when the pin violates the maximum sequential
  /// digits rule.
  final String maximumSequentialDigitsError;

  ///The function if succes set pin process
  final ValueChanged<User> onSuccess;

  /// Extra widget like contact us button
  final Widget? extraChild;

  /// Creates a new [SetAccessPinScreen].
  const SetAccessPinScreen({
    super.key,
    super.pinLength = 6,
    this.setPinAppBar,
    this.repeatPinAppBar,
    required this.onSuccess,
    required this.setPinTitle,
    required this.repeatPinTitle,
    required this.maximumRepetitiveCharactersError,
    required this.maximumSequentialDigitsError,
    this.extraChild,
  });

  /// The static page route for the set acces pin screen.
  static MaterialPageRoute pageRoute({
    required String userToken,
    int pinLength = 6,
    PreferredSizeWidget? setPinAppBar,
    PreferredSizeWidget? repeatPinAppBar,
    required String setPinTitle,
    required String repeatPinTitle,
    required String maximumRepetitiveCharactersError,
    required String maximumSequentialDigitsError,
    required ValueChanged<User?> onSuccess,
    Widget? extraChild,
  }) =>
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider<SetPinScreenCubit>(
              create: (context) => context
                  .read<SetPinScreenCreator>()
                  .create(userToken: userToken),
            ),
            BlocProvider<AccessPinValidationCubit>(
              create: (context) =>
                  context.read<AccessPinValidationCreator>().create(),
            ),
          ],
          child: SetAccessPinScreen(
            pinLength: pinLength,
            setPinAppBar: setPinAppBar,
            repeatPinAppBar: repeatPinAppBar,
            setPinTitle: setPinTitle,
            repeatPinTitle: repeatPinTitle,
            maximumRepetitiveCharactersError: maximumRepetitiveCharactersError,
            maximumSequentialDigitsError: maximumSequentialDigitsError,
            onSuccess: onSuccess,
            extraChild: extraChild,
          ),
        ),
      );

  @override
  State<SetAccessPinScreen> createState() => _SetAccessPinScreenState();
}

class _SetAccessPinScreenState
    extends SetAccessPinBaseWidgetState<SetAccessPinScreen> {
  void initState() {
    super.initState();
    final validationCubit = context.read<AccessPinValidationCubit>();
    validationCubit.load();
  }

  @override
  Widget build(BuildContext context) {
    final layerDesign = DesignSystem.of(context);

    return LayerScaffold(
      backgroundColor: layerDesign.surfaceOctonary1,
      appBar: widget.setPinAppBar,
      body: CubitActionBuilder<AccessPinValidationCubit,
              AccessPinValidationAction>(
          actions: {
            AccessPinValidationAction.loadSettings,
          },
          builder: (context, actions) {
            final busy = actions.isNotEmpty;
            return busy
                ? Center(child: DKLoader())
                : Column(
                    children: [
                      Expanded(
                        child: CubitErrorBuilder<AccessPinValidationCubit>(
                            builder: (context, errors) {
                          final errorMessage = errors.any((error) =>
                                  error is CubitValidationError &&
                                  error.validationErrorCode ==
                                      AccessPinValidationError
                                          .maximumRepetitiveCharacters)
                              ? widget.maximumRepetitiveCharactersError
                              : errors.any((error) =>
                                      error is CubitValidationError &&
                                      error.validationErrorCode ==
                                          AccessPinValidationError
                                              .maximumSequentialDigits)
                                  ? widget.maximumSequentialDigitsError
                                  : null;

                          return PinPadView(
                            pinLenght: widget.pinLength,
                            pin: accessPin,
                            title: widget.setPinTitle,
                            disabled: disabled,
                            warning: errorMessage ?? warning,
                            onChanged: (pin) {
                              context
                                  .read<AccessPinValidationCubit>()
                                  .clearValidationErrors();
                              accessPin = pin;
                              if (pin.length == widget.pinLength) {
                                _navigateToRepeatPinScreen();
                              }
                            },
                          );
                        }),
                      ),
                      if (widget.extraChild != null) widget.extraChild!,
                    ],
                  );
          }),
    );
  }

  /// Navigates to the repeat pin screen.
  Future<void> _navigateToRepeatPinScreen() async {
    final validationCubit = context.read<AccessPinValidationCubit>();
    validationCubit.validate(pin: accessPin);
    if (!validationCubit.state.valid) {
      accessPin = '';
      return;
    }

    disabled = true;

    final setPinScreenCubit = context.read<SetPinScreenCubit>();

    await Navigator.push<User>(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<SetPinScreenCubit>.value(
          value: setPinScreenCubit,
          child: Builder(
            builder: (context) => _RepeatAccessPinScreen(
              pinLength: widget.pinLength,
              pin: accessPin,
              appBar: widget.repeatPinAppBar,
              title: widget.repeatPinTitle,
              onSuccess: widget.onSuccess,
              extraChild: widget.extraChild,
            ),
          ),
        ),
      ),
    );

    final user = context.read<SetPinScreenCubit>().state.user;

    if (user == null) {
      disabled = false;
      accessPin = '';
    } else {
      Navigator.pop(context, user);
    }
  }
}

/// A screen for repeating an entered access pin screen.
class _RepeatAccessPinScreen extends SetAccessPinBaseWidget {
  /// The pin setted on the set access pin screen.
  final String pin;

  /// The app bar.
  final PreferredSizeWidget? appBar;

  /// The title for the repeat pin screen.
  final String title;

  ///The function if succes set pin process
  final ValueChanged<User> onSuccess;

  /// Extra widget like contact us button
  final Widget? extraChild;

  /// Creates a new [_RepeatAccessPinScreen].
  // ignore_for_file: unused_element
  const _RepeatAccessPinScreen({
    super.key,
    super.pinLength = 6,
    required this.pin,
    this.appBar,
    required this.title,
    required this.onSuccess,
    this.extraChild,
  });

  @override
  State<_RepeatAccessPinScreen> createState() => __RepeatAccessPinScreenState();
}

class __RepeatAccessPinScreenState
    extends SetAccessPinBaseWidgetState<_RepeatAccessPinScreen> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<SetPinScreenCubit>().state;

    return Stack(
      children: [
        BlocListener<SetPinScreenCubit, SetPinScreenState>(
          listenWhen: (previous, current) =>
              previous.user != current.user && current.user != null,
          listener: (context, state) => widget.onSuccess(state.user!),
          child: LayerScaffold(
            backgroundColor: DesignSystem.of(context).surfaceOctonary1,
            appBar: widget.appBar,
            body: WillPopScope(
              onWillPop: () async => !state.busy && state.user == null,
              child: Column(
                children: [
                  Expanded(
                    child: PinPadView(
                      pinLenght: widget.pinLength,
                      pin: accessPin,
                      title: widget.title,
                      disabled: !state.busy && disabled,
                      warning: state.errorMessage ?? warning,
                      onChanged: (pin) async {
                        accessPin = pin;
                        if (pin.length == widget.pinLength) {
                          if (pin != widget.pin) {
                            accessPin = '';
                            warning = Translation.of(context).translate(
                              'pin_code_error_password_not_match',
                            );
                          } else {
                            disabled = true;

                            await BottomSheetHelper.showConfirmation(
                              context: context,
                              titleKey: 'pass_code_done',
                              type: BottomSheetType.success,
                              showDenyButton: false,
                              confirmKey: 'ok',
                            );

                            context
                                .read<SetPinScreenCubit>()
                                .setAccesPin(pin: pin);
                          }
                        }
                      },
                    ),
                  ),
                  if (widget.extraChild != null) widget.extraChild!,
                ],
              ),
            ),
          ),
        ),
        if (state.busy)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
              child: Center(
                child: DKLoader(
                  size: 40.0,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
