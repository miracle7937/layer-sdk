import 'package:flutter/material.dart';

import '../../../../features/dpa.dart';
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

  /// Creates a new [DPASetAccessPin].
  const DPASetAccessPin({
    Key? key,
    required this.dpaVariable,
    this.header,
    required this.onAccessPinSet,
    int pinLenght = 6,
  }) : super(
          key: key,
          pinLenght: pinLenght,
        );

  @override
  State<DPASetAccessPin> createState() => _DPASetAccessPinState();
}

class _DPASetAccessPinState
    extends SetAccessPinBaseWidgetState<DPASetAccessPin> {
  @override
  void didUpdateWidget(covariant DPASetAccessPin oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dpaVariable != widget.dpaVariable) {
      currentPin = '';
    }
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          if (widget.header != null) widget.header!,
          Expanded(
            child: PinPadView(
              pinLenght: widget.dpaVariable.constraints.maxLength ?? 6,
              pin: currentPin,
              title: widget.dpaVariable.label ?? '',
              disabled: disabled,
              warning: warning,
              onChanged: (pin) {
                currentPin = pin;
                if (pin.length == widget.pinLenght) {
                  widget.onAccessPinSet(pin);
                }
              },
            ),
          ),
        ],
      );
}
