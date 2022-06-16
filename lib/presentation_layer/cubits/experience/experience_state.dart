import 'dart:collection';

import 'package:equatable/equatable.dart';
import '../../../domain_layer/models.dart';

/// The available errors.
enum ExperienceStateError {
  /// No errors reported.
  none,

  /// Generic error.
  generic,

  /// Network error.
  network,
}

/// A state representing the user experience in the app.
class ExperienceState extends Equatable {
  /// The experience data as configured in the Experience Studio.
  ///
  /// This field is null before the experience is fetched.
  final Experience? experience;

  /// A list of pages configured in the Experience Studio
  /// with user preferences applied.
  ///
  /// The pages are filtered based on the user preferred visibility
  /// and his permissions. The containers are sorted by his preferred order.
  ///
  /// This list is empty before the experience is fetched.
  final UnmodifiableListView<ExperiencePage> visiblePages;

  /// True if the cubit is processing something.
  final bool busy;

  /// Holds the current error
  final ExperienceStateError error;

  /// Holds the error message
  final String? errorMessage;

  /// Creates the [ExperienceState].
  ExperienceState({
    this.experience,
    Iterable<ExperiencePage>? visiblePages,
    this.busy = false,
    this.error = ExperienceStateError.none,
    this.errorMessage,
  }) : visiblePages = UnmodifiableListView(
          visiblePages ?? const <ExperiencePage>[],
        );

  /// Creates a new instance of [ExperienceState] based on this one.
  ExperienceState copyWith({
    Experience? experience,
    Iterable<ExperiencePage>? visiblePages,
    bool? busy,
    ExperienceStateError? error,
    String? errorMessage,
  }) =>
      ExperienceState(
        experience: experience ?? this.experience,
        visiblePages: visiblePages ?? this.visiblePages,
        busy: busy ?? this.busy,
        error: error ?? this.error,
        errorMessage: error == ExperienceStateError.none
            ? null
            : (errorMessage ?? this.errorMessage),
      );

  @override
  List<Object?> get props => [
        experience,
        visiblePages,
        busy,
        error,
        errorMessage,
      ];
}
