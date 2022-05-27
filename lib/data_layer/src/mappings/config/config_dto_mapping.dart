import '../../../models.dart';
import '../../dtos.dart';

/// Extension that provides mappings for [ConfigDTO]
extension ConfigDTOMapping on ConfigDTO {
  /// Maps into a [Config]
  Config toConfig() => Config(
        showCustomersTab: showCustomersTab ?? false,
        internalServices:
            internalServices?.toInternalServices() ?? InternalServices(),
      );
}

/// Extension that provides mappings for [InternalServicesDTO]
extension InternalServicesMapping on InternalServicesDTO {
  /// Maps into a [InternalServices]
  InternalServices toInternalServices() => InternalServices(
        infobanking: infobanking ?? '',
        authCustomer: authCustomer ?? '',
      );
}
