import 'package:equatable/equatable.dart';

import '../../../data_layer/data_layer.dart';
import '../../business_layer.dart';

/// Enum for all possible errors for [BrandingCubit]
enum BrandingStateErrors {
  /// No errors
  none,

  /// Generic error
  generic,
}

/// Enum for all possible actions for [BrandingCubit]
enum BrandingStateActions {
  /// No errors
  none,

  /// Loaded new branding
  newBranding,
}

/// Represents the state of [BrandingCubit]
class BrandingState extends Equatable {
  /// True if the cubit is processing something
  final bool busy;

  /// The current [Branding].
  final Branding branding;

  /// Error message for the last occurred error
  final BrandingStateErrors error;

  /// Last performed action
  final BrandingStateActions action;

  /// Creates a new instance of [BrandingState]
  BrandingState({
    this.branding = const LayerBranding(),
    this.busy = false,
    this.error = BrandingStateErrors.none,
    this.action = BrandingStateActions.none,
  });

  @override
  List<Object?> get props => [
        branding,
        busy,
        error,
        action,
      ];

  /// Creates a new instance of [BrandingState] based on the current instance
  BrandingState copyWith({
    Branding? branding,
    bool? busy,
    BrandingStateErrors? error,
    BrandingStateActions? action,
  }) =>
      BrandingState(
        branding: branding ?? this.branding,
        busy: busy ?? this.busy,
        error: error ?? this.error,
        action: action ?? this.action,
      );
}
