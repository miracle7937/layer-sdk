import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features/dpa.dart';
import '../../../cubits.dart';
import '../../../features.dart';
import '../../../widgets.dart';

/// A dpa widget for setting an access pin.
class DPASetAccessPin extends SetAccessPinBaseWidget {
  /// The dpa variable.
  final DPAVariable dpaVariable;

  /// The header.
  final Widget? header;

  /// The callback called when an access pin has been set.
  final ValueSetter<String> onAccessPinSet;

  /// The error to be displayed when the pin violates the maximum repetitive
  /// characters rule.
  final String maximumRepetitiveCharactersError;

  /// The error to be displayed when the pin violates the maximum sequential
  /// digits rule.
  final String maximumSequentialDigitsError;

  /// Creates a new [DPASetAccessPin].
  const DPASetAccessPin({
    super.key,
    required this.dpaVariable,
    this.header,
    required this.onAccessPinSet,
    required this.maximumRepetitiveCharactersError,
    required this.maximumSequentialDigitsError,
    super.pinLength = 6,
  });

  @override
  State<DPASetAccessPin> createState() => _DPASetAccessPinState();
}

class _DPASetAccessPinState
    extends SetAccessPinBaseWidgetState<DPASetAccessPin> {
  @override
  void initState() {
    super.initState();
    final validationCubit = context.read<AccessPinValidationCubit>();
    validationCubit.load();
  }

  @override
  void didUpdateWidget(covariant DPASetAccessPin oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dpaVariable != widget.dpaVariable) {
      accessPin = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return CubitActionBuilder<AccessPinValidationCubit,
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
                  if (widget.header != null) widget.header!,
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
                        pinLenght:
                            widget.dpaVariable.constraints.maxLength ?? 6,
                        pin: accessPin,
                        title: widget.dpaVariable.label ?? '',
                        disabled: disabled,
                        warning: errorMessage ?? warning,
                        onChanged: (pin) {
                          final validationCubit =
                              context.read<AccessPinValidationCubit>();
                          validationCubit.clearValidationErrors();
                          accessPin = pin;

                          if (pin.length == widget.pinLength) {
                            validationCubit.validate(pin: accessPin);
                            if (!validationCubit.state.valid) {
                              accessPin = '';
                              return;
                            }
                            widget.onAccessPinSet(pin);
                          }
                        },
                      );
                    }),
                  ),
                ],
              );
      },
    );
  }
}
