import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Available errors
enum LocalizationError {
  /// No errors
  none,

  /// Generic error
  generic,
}

/// A state representing [Locale] selected by the user.
class LocalizationState extends Equatable {
  /// Current [Locale] selected by the user.
  final Locale locale;

  /// Whether the cubit is busy processing.
  final bool busy;

  /// The current error.
  final LocalizationError error;

  /// Creates [LocalizationState].
  LocalizationState({
    required this.locale,
    this.busy = false,
    this.error = LocalizationError.none,
  });

  /// Creates a copy of the current object with selected new values.
  LocalizationState copyWith({
    Locale? locale,
    bool? busy,
    LocalizationError? error,
  }) =>
      LocalizationState(
        locale: locale ?? this.locale,
        busy: busy ?? this.busy,
        error: error ?? this.error,
      );

  @override
  List<Object?> get props => [
        locale,
        busy,
        error,
      ];
}
