import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../payment/biller_dto_mapping.dart';
import 'service_field_dto_mapping.dart';

/// Extension that provides mappings for [ServiceDTO]
extension ServiceDTOMapping on ServiceDTO {
  /// Maps into a [Service]
  Service toService() => Service(
        serviceId: serviceId,
        billerId: billerId,
        biller: biller?.toBiller(),
        name: name,
        billingIdTag: billingIdTag,
        billingIdTagHelp: billingIdTagHelp,
        billingIdDesc: billingIdDesc,
        created: created,
        updated: updated,
        serviceFields: (serviceFields ?? [])
            .map((e) => e.toServiceField())
            .toList(growable: false),
      );
}

/// Extension that provides mappings for [Service]
extension ServiceToDTOMapping on Service {
  /// Maps into a [ServiceDTO]
  ServiceDTO toServiceDTO() {
    return ServiceDTO(
      serviceId: serviceId,
      billerId: billerId,
      name: name,
      billingIdTag: billingIdTag,
      billingIdTagHelp: billingIdTagHelp,
      billingIdDesc: billingIdDesc,
      created: created,
      updated: updated,
      serviceFields: serviceFields
          .map((e) => e.toServiceFieldDTO())
          .toList(growable: false),
    );
  }
}
