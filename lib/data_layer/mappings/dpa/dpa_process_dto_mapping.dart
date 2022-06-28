import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../mappings.dart';

/// Extension that provides mappings for [DPAProcessDTO]
extension DPAProcessDTOMapping on DPAProcessDTO {
  /// Maps into a [DPAProcess]
  DPAProcess toDPAProcess(
    DPAMappingCustomData customData, {
    DPAProcess? currentProcess,
  }) {
    final dpaProps = processProperties?.toDPAProcessProperties(
          currentProperties: currentProcess?.properties,
        ) ??
        currentProcess?.properties;

    final stepName = properties?.step;

    return DPAProcess(
      step: (dpaProps?.steps.indexOf(stepName) ?? -1) + 1,
      stepCount: dpaProps?.steps.length ?? 0,
      stepName: stepName ?? '',
      finished: finished,
      status: status?.toDPAStatus() ?? DPAStatus.active,
      properties: dpaProps,
      stepProperties: properties?.toDPAProcessStepProperties(customData),
      task: task?.toDPATask(customData),
      variables: variables?.toDPAVariableList(customData),
      processName:
          task?.processDefinitionName ?? currentProcess?.processName ?? '',
    );
  }
}

/// Extension that provides mappings for [DPAProcess]
extension DPAProcessMapping on DPAProcess {
  /// Maps into a [DPAProcessDTO]
  DPAProcessDTO toDPAProcessDTO() => DPAProcessDTO(
        task: task?.toDPATaskDTO(),
        variables: variables.toDPAVariableDTOMap(),
      );
}

/// Extension that provides mappings for Map<String, String> related to
/// [DPAProcess]
extension DPAProcessPropertiesMapping on Map<String, dynamic> {
  /// Maps into a [DPAProcessProperties]
  DPAProcessProperties toDPAProcessProperties({
    DPAProcessProperties? currentProperties,
  }) {
    List<String>? steps;

    for (final key in keys) {
      if (key.toLowerCase().startsWith('step')) {
        steps ??= <String>[];

        steps.add(this[key]);
      }
    }

    return currentProperties?.copyWith(
          steps: steps,
          tag: this['tag'],
        ) ??
        DPAProcessProperties(
          steps: steps ?? <String>[],
          tag: this['tag'],
        );
  }
}
