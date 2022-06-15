import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../../domain_layer/models/setting/global_setting.dart';

/// The available errors.
enum GlobalSettingError {
  /// No errors reported.
  none,

  /// Generic error.
  generic,

  /// Network error.
  network,
}

/// The state of the [GlobalSettingCubit].
class GlobalSettingState extends Equatable {
  /// The list of already fetched settings.
  final UnmodifiableListView<GlobalSetting> settings;

  /// True if the cubit is processing something.
  final bool busy;

  /// The current error.
  final GlobalSettingError error;

  /// The error message.
  final String? errorMessage;

  /// Creates [GlobalSettingState].
  GlobalSettingState({
    Iterable<GlobalSetting> settings = const <GlobalSetting>[],
    this.busy = false,
    this.error = GlobalSettingError.none,
    this.errorMessage,
  }) : settings = UnmodifiableListView(settings);

  @override
  List<Object?> get props => [
        settings,
        busy,
        error,
        errorMessage,
      ];

  /// Creates a new instance based on this one.
  GlobalSettingState copyWith({
    Iterable<GlobalSetting>? settings,
    bool? busy,
    GlobalSettingError? error,
    String? errorMessage,
  }) =>
      GlobalSettingState(
        settings: settings ?? this.settings,
        busy: busy ?? this.busy,
        error: error ?? this.error,
        errorMessage: error == GlobalSettingError.none
            ? null
            : (errorMessage ?? this.errorMessage),
      );

  /// Returns the value of a setting.
  T? getSetting<T>({
    required String module,
    required String code,
  }) {
    final setting = settings.firstWhereOrNull(
      (element) =>
          element is GlobalSetting<T> &&
          element.module == module &&
          element.code == code,
    );

    return setting?.value;
  }
}
