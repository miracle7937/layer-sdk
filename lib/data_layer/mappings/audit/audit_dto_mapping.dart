import '../../../domain_layer/models.dart';
import '../../dtos.dart';

/// Extension that provides mapping for [AuditDTO]
extension AuditDTOMapping on AuditDTO {
  /// Maps into [Audit]
  Audit toAudit() => Audit(
        aUserId: aUserId,
        auditId: auditId,
        countTotal: countTotal,
        created: dateCreated,
        deviceId: deviceId,
        ipAddress: ipAddress ?? '',
        method: method ?? '',
        objectId: objectId ?? '',
        objectName: objectName ?? '',
        parameters: parameters ?? '',
        serverResponseCode: serverResponseCode ?? '',
        serverResponseMessage: serverResponseMessage ?? '',
        serviceName: serviceName ?? '',
        url: url ?? '',
        userAgent: userAgent ?? '',
        userType: userType ?? '',
        username: username ?? '',
        uuid: uuid ?? '',
      );
}

/// Extension that provides mappings for [AuditSort]
extension AuditSortMapping on AuditSort {
  /// Maps into a [String]
  String toFieldName() {
    switch (this) {
      case AuditSort.date:
        return 'audit.ts_created';
      case AuditSort.serviceName:
        return 'service_name';
    }
  }
}
