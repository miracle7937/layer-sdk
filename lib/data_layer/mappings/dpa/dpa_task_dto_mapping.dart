import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../extensions.dart';
import '../../mappings.dart';

/// Extension that provides mappings for [DPATaskDTO]
extension DPATaskDTOMapping on DPATaskDTO {
  /// Maps into a [DPATask]
  DPATask toDPATask(DPAMappingCustomData customData) => DPATask(
        id: id ?? '',
        name: name ?? '',
        status: status?.toDPAStatus() ?? DPAStatus.active,
        priority: priority,
        description: description,
        created: created?.toDate(),
        due: due?.toDate(),
        preVariables:
            preVariables?.toDPAVariableList(customData) ?? <DPAVariable>[],
        variables:
            taskVariables?.toDPAVariableList(customData) ?? <DPAVariable>[],
        executionId: executionId,
        processInstanceId: processInstanceId,
        activityInstanceId: activityInstanceId,
        processDefinitionKey: processDefinitionKey ?? '',
        processKey: processKey ?? '',
        processDefinitionName: processDefinitionName ?? '',
        previousTasksIds: (previousTasks?.isEmpty ?? true)
            ? <String>[]
            : previousTasks!.sublist(0, previousTasks!.length - 1),
      );
}

/// Extension that provides mappings for [DPATask]
extension DPATaskMapping on DPATask {
  /// Maps into a [DPATaskDTO]
  DPATaskDTO toDPATaskDTO() => DPATaskDTO(
        id: id,
        name: name,
        status: status.toDPAStatusDTO(),
        priority: priority,
        description: description,
        created: created?.toDTOString(),
        due: due?.toDTOString(),
        preVariables: preVariables.toDPAVariableDTOList(),
        taskVariables: variables.toDPAVariableDTOMap(),
        executionId: executionId,
        processInstanceId: processInstanceId,
        activityInstanceId: activityInstanceId,
        previousTasks: previousTasksIds,
      );
}
