import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../models.dart';

/// Holds the information about a DPA task.
///
/// Only the data needed for the app is here, so if you need something
/// else, feel free to add.
class DPATask extends Equatable {
  /// The task id.
  final String id;

  /// The task name.
  final String name;

  /// The status of this task.
  final DPAStatus status;

  /// The priority number.
  final int? priority;

  /// Description of the task.
  final String? description;

  /// Date the task was created.
  final DateTime? created;

  /// Date the task is due.
  final DateTime? due;

  /// The customer who owns this process.
  ///
  /// Null if this task is not for a customer.
  final Customer? customer;

  /// The list of pre-variables.
  final UnmodifiableListView<DPAVariable> preVariables;

  /// The list of variables for this task.
  final UnmodifiableListView<DPAVariable> variables;

  /// The execution id.
  final String? executionId;

  /// The process instance id.
  final String? processInstanceId;

  /// The activity instance id.
  final String? activityInstanceId;

  /// The key of the DPA process.
  final String processDefinitionKey;

  /// The name of the DPA process.
  final String processDefinitionName;

  /// The process key.
  final String processKey;

  /// The ids of the tasks that come before this one.
  final UnmodifiableListView<String> previousTasksIds;

  /// The activity description
  final String? activityDescription;

  /// Creates a new [DPATask].
  DPATask({
    required this.id,
    required this.name,
    required this.status,
    this.priority,
    this.description,
    this.created,
    this.due,
    this.customer,
    Iterable<DPAVariable> preVariables = const [],
    Iterable<DPAVariable> variables = const [],
    this.executionId,
    this.processInstanceId,
    this.activityInstanceId,
    this.processDefinitionKey = '',
    this.processDefinitionName = '',
    this.processKey = '',
    this.activityDescription,
    Iterable<String> previousTasksIds = const [],
  })  : preVariables = UnmodifiableListView<DPAVariable>(preVariables),
        variables = UnmodifiableListView<DPAVariable>(variables),
        previousTasksIds = UnmodifiableListView(previousTasksIds);

  @override
  List<Object?> get props => [
        id,
        name,
        status,
        priority,
        description,
        created,
        due,
        customer,
        preVariables,
        variables,
        executionId,
        processInstanceId,
        activityInstanceId,
        processDefinitionKey,
        processDefinitionName,
        previousTasksIds,
        processKey,
        activityDescription,
      ];

  /// Returns if the task is open
  bool get isOpen => [
        DPAStatus.active,
        DPAStatus.pendingUserApproval,
        DPAStatus.editRequested,
        DPAStatus.pendingBankApproval,
      ].contains(status);

  /// Returns if the task is closed
  bool get isClosed => [
        DPAStatus.completed,
        DPAStatus.rejected,
      ].contains(status);

  /// Creates a new [DPATask] using another as a base.
  DPATask copyWith({
    String? id,
    String? name,
    DPAStatus? status,
    int? priority,
    String? description,
    DateTime? created,
    DateTime? due,
    Customer? customer,
    Iterable<DPAVariable>? preVariables,
    Iterable<DPAVariable>? variables,
    String? executionId,
    String? processInstanceId,
    String? activityInstanceId,
    String? processDefinitionKey,
    String? processDefinitionName,
    String? processKey,
    List<String>? previousTasksIds,
    String? activityDescription,
  }) =>
      DPATask(
        id: id ?? this.id,
        name: name ?? this.name,
        status: status ?? this.status,
        priority: priority ?? this.priority,
        description: description ?? this.description,
        created: created ?? this.created,
        due: due ?? this.due,
        customer: customer ?? this.customer,
        preVariables: preVariables ?? this.preVariables,
        variables: variables ?? this.variables,
        executionId: executionId ?? this.executionId,
        processInstanceId: processInstanceId ?? this.processInstanceId,
        activityInstanceId: activityInstanceId ?? this.activityInstanceId,
        processDefinitionKey: processDefinitionKey ?? this.processDefinitionKey,
        processDefinitionName:
            processDefinitionName ?? this.processDefinitionName,
        previousTasksIds: previousTasksIds ?? this.previousTasksIds,
        processKey: processKey ?? this.processKey,
        activityDescription: activityDescription ?? this.activityDescription,
      );
}
