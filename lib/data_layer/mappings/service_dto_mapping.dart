import '../../domain_layer/models.dart';
import '../dtos.dart';

/// Extension that provides mappings for [ServiceDTO]
extension ServiceDTOMapping on ServiceDTO {
  /// Maps into a [Service]
  Service toService() => Service(
        serviceId: serviceId,
        billerId: billerId,
        name: name,
        billingIdTag: billingIdTag,
        billingIdTagHelp: billingIdTagHelp,
        billingIdDesc: billingIdDesc,
        created: created,
        updated: updated,
      );
}
