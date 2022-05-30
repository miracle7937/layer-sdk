import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../../models.dart';

/// Holds the information about an ongoing DPA process.
class DPAProcess extends Equatable {
  /// The number of the current step.
  final int step;

  /// How many steps there are on this process.
  final int stepCount;

  /// The name of the current step.
  final String stepName;

  /// If the process has finished.
  final bool finished;

  /// The current status of this process.
  final DPAStatus status;

  /// The properties associated with the whole process.
  final DPAProcessProperties? properties;

  /// The properties associated with the current step of the process.
  final DPAProcessStepProperties? stepProperties;

  /// The task associated with the current step of the process.
  final DPATask? task;

  /// The variables associated with the current step of the process.
  final UnmodifiableListView<DPAVariable> variables;

  /// The name of this process.
  final String processName;

  /// If it's clear to proceed to the next step.
  bool get canProceed =>
      variables.firstWhereOrNull(
        (e) =>
            // We check both the validation and the required as the variables
            // start not validated (to prevent for showing errors before the
            // user typing something).
            (e.constraints.required) && e.value == null || e.hasValidationError,
      ) ==
      null;

  /// If the user can go back to a previous step.
  bool get canGoBack => true; // For now, the user can always go back.

  /// Creates a new [DPAProcess].
  DPAProcess({
    this.step = 0,
    this.stepCount = 0,
    this.stepName = '',
    this.finished = false,
    this.status = DPAStatus.active,
    this.properties,
    this.stepProperties,
    this.task,
    Iterable<DPAVariable>? variables,
    this.processName = '',
  }) : variables = UnmodifiableListView(variables ?? []);

  @override
  List<Object?> get props => [
        step,
        stepCount,
        stepName,
        finished,
        status,
        properties,
        stepProperties,
        task,
        variables,
        processName,
      ];

  /// Creates a new [DPAProcess] using another as a base.
  DPAProcess copyWith({
    bool? finished,
    DPAStatus? status,
    DPAProcessProperties? properties,
    DPAProcessStepProperties? stepProperties,
    DPATask? task,
    Iterable<DPAVariable>? variables,
    int? step,
    int? stepCount,
    String? stepName,
    String? processName,
  }) =>
      DPAProcess(
        finished: finished ?? this.finished,
        status: status ?? this.status,
        properties: properties ?? this.properties,
        stepProperties: stepProperties ?? this.stepProperties,
        task: task ?? this.task,
        variables: variables ?? this.variables,
        step: step ?? this.step,
        stepCount: stepCount ?? this.stepCount,
        stepName: stepName ?? this.stepName,
        processName: processName ?? this.processName,
      );

  /// Returns a new [DPAProcess] validating all variables
  DPAProcess validate() {
    return copyWith(
      variables: variables.map(
        (e) => e.validateAndCopyWith(),
      ),
    );
  }
}

/// Holds properties that describe a process.
class DPAProcessProperties extends Equatable {
  /// The list of steps available for this process.
  final UnmodifiableListView<String> steps;

  /// The tag of this process.
  final String? tag;

  /// Creates a new [DPAProcessProperties].
  DPAProcessProperties({
    Iterable<String> steps = const <String>[],
    this.tag,
  }) : steps = UnmodifiableListView(steps);

  @override
  List<Object?> get props => [
        steps,
        tag,
      ];

  /// Creates a new [DPAProcessProperties] using another as a base.
  DPAProcessProperties copyWith({
    Iterable<String>? steps,
    String? tag,
  }) =>
      DPAProcessProperties(
        steps: steps ?? this.steps,
        tag: tag ?? this.tag,
      );
}
