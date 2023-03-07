import 'package:flutter/material.dart';

/// A base class for the set acces pin views to extends from it.
abstract class SetAccessPinBaseWidget extends StatefulWidget {
  /// The pin length.
  /// Default is 6.
  final int pinLength;

  /// Creates a new [SetAccessPinBaseWidget].
  const SetAccessPinBaseWidget({
    Key? key,
    this.pinLength = 6,
  }) : super(key: key);
}

/// The base state for the set access pin views.
abstract class SetAccessPinBaseWidgetState<W extends SetAccessPinBaseWidget>
    extends State<W> {
  /// The current pin.
  String _currentPin = '';

  /// The getter for the current pin.
  String get accessPin => _currentPin;

  /// The setter for the current pin.
  set accessPin(String pin) {
    if (pin.length <= widget.pinLength) {
      setState(() => _currentPin = pin);
    }
    if (accessPin.isNotEmpty && warning != null) {
      warning = null;
    }
  }

  /// The warning text.
  String? _warning;

  /// The getter for the warning text.
  String? get warning => _warning;

  /// The setter for the warning text.
  set warning(String? warning) => setState(() => _warning = warning);

  /// The disabled state for the pin pad.
  bool _disabled = false;

  /// The getter for the disabled state for the pin pad.
  bool get disabled => _disabled;

  /// The setter for the disabled state for the pin pad.
  set disabled(bool disabled) => setState(() => _disabled = disabled);
}
