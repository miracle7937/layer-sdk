import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../../data_layer/data_layer.dart';

/// The available error status
enum DPAProcessDefinitionsErrorStatus {
  /// No errors
  none,

  /// Network error
  network,
}

/// The state that holds the DPA process definitions.
class DPAProcessDefinitionsState extends Equatable {
  /// The list of processes available.
  final UnmodifiableListView<DPAProcessDefinition> definitions;

  /// If this cubit is busy doing some work.
  final bool busy;

  /// The current error status.
  final DPAProcessDefinitionsErrorStatus errorStatus;

  /// Creates a new [DPAProcessDefinitionsState].
  DPAProcessDefinitionsState({
    Iterable<DPAProcessDefinition> definitions = const <DPAProcessDefinition>[],
    this.busy = false,
    this.errorStatus = DPAProcessDefinitionsErrorStatus.none,
  }) : definitions = UnmodifiableListView(definitions);

  @override
  List<Object?> get props => [
        definitions,
        busy,
        errorStatus,
      ];

  /// Creates a [DPAProcessDefinitionsState] based on this one.
  DPAProcessDefinitionsState copyWith({
    Iterable<DPAProcessDefinition>? definitions,
    bool? busy,
    DPAProcessDefinitionsErrorStatus? errorStatus,
  }) =>
      DPAProcessDefinitionsState(
        definitions: definitions ?? this.definitions,
        busy: busy ?? this.busy,
        errorStatus: errorStatus ?? this.errorStatus,
      );
}
