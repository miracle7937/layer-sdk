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

  /// Creates a new [SetAccessPinScreen].
  const SetAccessPinScreen({
    super.key,
    super.pinLength = 6,
    this.setPinAppBar,
    this.repeatPinAppBar,
    required this.setPinTitle,
    required this.repeatPinTitle,
  });

  /// The static page route for the set acces pin screen.
  static MaterialPageRoute pageRoute({
    required String userToken,
    int pinLength = 6,
    PreferredSizeWidget? setPinAppBar,
    PreferredSizeWidget? repeatPinAppBar,
    required String setPinTitle,
    required String repeatPinTitle,
  }) =>
      MaterialPageRoute(
        builder: (context) => BlocProvider<SetPinScreenCubit>(
          create: (context) => context.read<SetPinScreenCreator>().create(
                userToken: userToken,
              ),
          child: SetAccessPinScreen(
            pinLength: pinLength,
            setPinAppBar: setPinAppBar,
            repeatPinAppBar: repeatPinAppBar,
            setPinTitle: setPinTitle,
            repeatPinTitle: repeatPinTitle,
          ),
        ),
      );

  @override
  State<SetAccessPinScreen> createState() => _SetAccessPinScreenState();
}

class _SetAccessPinScreenState
    extends SetAccessPinBaseWidgetState<SetAccessPinScreen> {
  @override
  Widget build(BuildContext context) {
    final layerDesign = DesignSystem.of(context);

    return Scaffold(
      backgroundColor: layerDesign.surfaceOctonary1,
      appBar: widget.setPinAppBar,
      body: PinPadView(
        pinLenght: widget.pinLength,
        pin: currentPin,
        title: widget.setPinTitle,
        disabled: disabled,
        warning: warning,
        onChanged: (pin) {
          currentPin = pin;
          if (pin.length == widget.pinLength) {
            _navigateToRepeatPinScreen();
          }
        },
      ),
    );
  }

  /// Navigates to the repeat pin screen.
  Future<void> _navigateToRepeatPinScreen() async {
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
              pin: currentPin,
              appBar: widget.repeatPinAppBar,
              title: widget.repeatPinTitle,
            ),
          ),
        ),
      ),
    );

    final user = context.read<SetPinScreenCubit>().state.user;

    if (user == null) {
      disabled = false;
      currentPin = '';
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

  /// Creates a new [_RepeatAccessPinScreen].
  // ignore_for_file: unused_element
  const _RepeatAccessPinScreen({
    super.key,
    super.pinLength = 6,
    required this.pin,
    this.appBar,
    required this.title,
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
          listener: (context, state) => Navigator.pop(context),
          child: Scaffold(
            backgroundColor: DesignSystem.of(context).surfaceOctonary1,
            appBar: widget.appBar,
            body: WillPopScope(
              onWillPop: () async => !state.busy && state.user == null,
              child: PinPadView(
                pinLenght: widget.pinLength,
                pin: currentPin,
                title: widget.title,
                disabled: !state.busy && disabled,
                warning: state.errorMessage ?? warning,
                onChanged: (pin) async {
                  currentPin = pin;
                  if (pin.length == widget.pinLength) {
                    if (pin != widget.pin) {
                      currentPin = '';
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

                      context.read<SetPinScreenCubit>().setAccesPin(pin: pin);
                    }
                  }
                },
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
