import '../../../domain_layer/models.dart';
import '../../dtos.dart';

/// Mapper for [MoreInfoDTO] class
extension MoreInfoDTOMapper on MoreInfoFieldDTO {
  /// Maps [MoreInfoDTO] to [MoreInfo]
  MoreInfoField toMoreInfoField() {
    return MoreInfoField(
      description: description ?? '',
      label: label ?? '',
      value: value ?? '',
      formattedValue: formattedValue,
    );
  }
}

/// Mapper for [MoreInfo] class
extension MoreInfoMapper on MoreInfoField {
  /// Maps [MoreInfo] to [MoreInfoDTO]
  MoreInfoFieldDTO toMoreInfoFieldDTO() {
    return MoreInfoFieldDTO(
      description: description,
      label: label,
      value: value,
      formattedValue: formattedValue,
    );
  }
}
