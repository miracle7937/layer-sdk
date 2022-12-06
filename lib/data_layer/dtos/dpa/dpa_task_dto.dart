import '../../dtos.dart';

/// Holds the data of a DPA Task.
class DPATaskDTO {
  /// To whom the task is assigned.
  final String? assignee;

  /// Date the task was created as a string.
  final String? created;

  /// Description of the task.
  final String? description;

  /// Date the task is due as a string.
  final String? due;

  /// The execution id.
  final String? executionId;

  /// The task id.
  final String? id;

  /// The task name.
  final String? name;

  /// The priority number.
  final int? priority;

  /// The id for the activity instance.
  final String? activityInstanceId;

  /// The ids of the previous tasks.
  final List<String>? previousTasks;

  /// The process definition id.
  final String? processDefinitionId;

  /// The process definition name.
  final String? processDefinitionName;

  /// The process definition key.
  final String? processDefinitionKey;

  /// The process instance id.
  final String? processInstanceId;

  /// The owner of this process
  final String? processOwner;

  /// Reference.
  final String? reference;

  /// If it's suspended.
  final bool? suspended;

  /// The current status of the task.
  final DPAStatusDTO? status;

  /// The date the status was last changed as a string.
  final String? statusUpdate;

  /// The task definition key.
  final String? taskDefinitionKey;

  /// The list of pre-variables.
  final List<DPAVariableDTO>? preVariables;

  /// The list of variables for this task.
  final Map<String, DPAVariableDTO>? taskVariables;

  /// The process key.
  final String? processKey;

  /// The activity description
  final String? activityDescription;

  /// Creates a new [DPATaskDTO].
  DPATaskDTO({
    this.assignee,
    this.created,
    this.description,
    this.due,
    this.executionId,
    this.id,
    this.name,
    this.priority,
    this.activityInstanceId,
    this.previousTasks,
    this.processDefinitionId,
    this.processDefinitionName,
    this.processDefinitionKey,
    this.processInstanceId,
    this.processOwner,
    this.reference,
    this.suspended,
    this.status,
    this.statusUpdate,
    this.taskDefinitionKey,
    this.preVariables,
    this.taskVariables,
    this.processKey,
    this.activityDescription,
  });

  /// Creates a new [DPATaskDTO] from a JSON.
  factory DPATaskDTO.fromJson(Map<String, dynamic> json) => DPATaskDTO(
      assignee: json['assignee'],
      created: json['created'],
      description: json['description'],
      due: json['due'],
      executionId: json['executionId'],
      id: json['id'],
      name: json['name'],
      processKey: json['processKey'],
      priority: json['priority'],
      activityInstanceId: json['activityInstanceId'],
      previousTasks: List<String>.from(json['previous_task'] ?? []),
      processDefinitionId: json['processDefinitionId'],
      processDefinitionName: json['processDefinitionName'],
      processDefinitionKey: json['processDefinitionKey'],
      processInstanceId: json['processInstanceId'],
      processOwner: _cleanProcessOwner(json['process_owner']),
      reference: json['reference'],
      suspended: json['suspended'] is String
          ? json['suspended'] != '0'
          : json['suspended'],
      status: DPAStatusDTO.fromRaw(json['Status']) ??
          DPAStatusDTO.fromRaw(json['status']),
      statusUpdate: json['statusUpdate'],
      taskDefinitionKey: json['taskDefinitionKey'],
      preVariables: json['PreVariables'] == null
          ? null
          : DPAVariableDTO.fromJsonList(
              List<Map<String, dynamic>>.from(json['PreVariables'])),
      taskVariables: json['taskVariables'] == null
          ? null
          : DPAVariableDTO.fromJsonMap(json['taskVariables']['variables']),
      activityDescription: json['activity_description']);

  static String? _cleanProcessOwner(String? jsonValue) {
    if (jsonValue == null || jsonValue.isEmpty) return null;

    final slashIndex = jsonValue.indexOf('/');

    if (slashIndex >= 0) return jsonValue.substring(0, slashIndex);

    return jsonValue;
  }

  /// Returns a list of [DPATaskDTO] based on the given list of JSONs.
  static List<DPATaskDTO> fromJsonList(List<Map<String, dynamic>> json) =>
      json.map(DPATaskDTO.fromJson).toList();

  @override
  String toString() => 'DPAConstraintDTO{'
      '${assignee != null ? ' assignee: $assignee' : ''}'
      '${created != null ? ' created: $created' : ''}'
      '${description != null ? ' description: $description' : ''}'
      '${due != null ? ' due: $due' : ''}'
      '${executionId != null ? ' executionId: $executionId' : ''}'
      '${id != null ? ' id: $id' : ''}'
      '${name != null ? ' name: $name' : ''}'
      '${priority != null ? ' priority: $priority' : ''}'
      '${processDefinitionId != null ? ' processDefinitionId: '
          '$processDefinitionId' : ''}'
      '${processDefinitionName != null ? ' processDefinitionName: '
          '$processDefinitionName' : ''}'
      '${processDefinitionKey != null ? ' processDefinitionKey: '
          '$processDefinitionKey' : ''}'
      '${processInstanceId != null ? ' processInstanceId: '
          '$processInstanceId' : ''}'
      '${processOwner != null ? ' processOwner: $processOwner' : ''}'
      '${reference != null ? ' reference: $reference' : ''}'
      '${suspended != null ? ' suspended: $suspended' : ''}'
      '${status != null ? ' status: $status' : ''}'
      '${statusUpdate != null ? ' statusUpdate: $statusUpdate' : ''}'
      '${taskDefinitionKey != null ? ' taskDefinitionKey: '
          '$taskDefinitionKey' : ''}'
      '${preVariables != null ? ' preVariables: $preVariables' : ''}'
      '${processKey != null ? ' processKey: $processKey' : ''}'
      '${taskVariables != null ? ' taskVariables: $taskVariables' : ''}'
      '${activityDescription != null ? ' activityDescription:'
          ' $activityDescription' : ''}'
      '}';
}
