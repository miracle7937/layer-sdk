import '../../../domain_layer/models.dart';
import '../../dtos.dart';

/// Extension that provides mapping
/// from [SaveExperiencePreferencesParametersDTO]
/// to [SaveExperiencePreferencesParameters].
extension SaveExperiencePreferencesParametersDTOMapping
    on SaveExperiencePreferencesParametersDTO {
  /// Returns a [SaveExperiencePreferencesParameters].
  SaveExperiencePreferencesParameters toSaveExperiencePreferencesParameters() =>
      SaveExperiencePreferencesParameters(
        containerId: containerId ?? '',
        key: key ?? '',
        value: value ?? '',
      );
}

/// Extension that provides mapping
/// from [SaveExperiencePreferencesParameters]
/// to [SaveExperiencePreferencesParametersDTO].
extension SaveExperiencePreferencesParametersMapping
    on SaveExperiencePreferencesParameters {
  /// Returns a [SaveExperiencePreferencesParametersDTO].
  SaveExperiencePreferencesParametersDTO
      toSaveExperiencePreferencesParametersDTO() =>
          SaveExperiencePreferencesParametersDTO(
            containerId: containerId,
            key: key,
            value: value,
          );
}
