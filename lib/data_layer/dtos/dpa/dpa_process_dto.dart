import '../../dtos.dart';

/// Holds an ongoing DPA process.
class DPAProcessDTO {
  /// The message associated to this process step.
  final String? message;

  /// The result of the action described on [message].
  final bool action;

  /// If the process has finished.
  final bool finished;

  /// The status of this process step
  final DPAStatusDTO? status;

  /// The properties associated with the whole process.
  final Map<String, dynamic>? processProperties;

  /// The properties associated with this process step.
  final DPAProcessStepPropertiesDTO? properties;

  /// The task associated with this process step.
  final DPATaskDTO? task;

  /// Variables available on this step of the process
  final Map<String, DPAVariableDTO>? variables;

  /// The variables returned when the process is finished.
  final List<Map<String, dynamic>>? returnVariables;

  /// Creates a new [DPAProcessDTO].
  DPAProcessDTO({
    this.message,
    this.action = false,
    this.finished = false,
    this.status,
    this.processProperties,
    this.properties,
    this.task,
    this.variables,
    this.returnVariables,
  });

  /// Creates a new [DPAProcessDTO] from a JSON.
  factory DPAProcessDTO.fromJson(Map<String, dynamic> json) => DPAProcessDTO(
        message: json['message'],
        finished: json['message'] == 'process_finished',
        action: json['action'] ?? false,
        status: DPAStatusDTO.fromRaw(json['status']),
        processProperties: json['process_properties'],
        properties: json['properties'] == null
            ? null
            : DPAProcessStepPropertiesDTO.fromJson(json['properties']),
        task: json['task'] == null ? null : DPATaskDTO.fromJson(json['task']),
        variables: json['variables'] == null
            ? null
            : DPAVariableDTO.fromJsonMap(json['variables']),
        returnVariables: json['return_variables'] == null
            ? null
            : List<Map<String, dynamic>>.from(
                json['return_variables'],
              ),
      );
}
