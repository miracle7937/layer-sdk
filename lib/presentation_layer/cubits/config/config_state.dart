import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';

/// Enum for all possible errors for [ConfigCubit]
enum ConfigStateErrors {
  /// No errors
  none,

  /// Generic error
  generic,
}

/// Represents the state of [ConfigCubit]
class ConfigState extends Equatable {
  /// True if the cubit is processing something
  /// Defaults to `false`.
  final bool busy;

  /// The current [Config].
  /// Defaults to `const Config()`.
  final Config config;

  /// The last occurred error
  /// Defaults to [ConfigStateErrors.none].
  final ConfigStateErrors error;

  /// Creates a new instance of [ConfigState]
  ConfigState({
    this.config = const Config(),
    this.busy = false,
    this.error = ConfigStateErrors.none,
  });

  @override
  List<Object?> get props => [
        config,
        busy,
        error,
      ];

  /// Creates a new instance of [ConfigState] based on the current instance
  ConfigState copyWith({
    Config? config,
    bool? busy,
    ConfigStateErrors? error,
  }) =>
      ConfigState(
        config: config ?? this.config,
        busy: busy ?? this.busy,
        error: error ?? this.error,
      );
}
