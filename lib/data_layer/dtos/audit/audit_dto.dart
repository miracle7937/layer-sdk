import '../../helpers.dart';

/// Holds the provider data for an audit
class AuditDTO {
  /// The ID of the user who made the request
  int? aUserId;

  /// The audit ID
  int? auditId;

  /// The total count of the audits in the database
  int? countTotal;

  /// The ID of the device from which the request was made
  int? deviceId;

  /// The IP address of the device from which the request was made
  String? ipAddress;

  /// The request method
  String? method;

  /// The request object ID
  String? objectId;

  /// The request object name
  String? objectName;

  /// The request parameters
  String? parameters;

  /// The response code
  String? serverResponseCode;

  /// The response message
  String? serverResponseMessage;

  /// The service to which the request was made
  String? serviceName;

  /// The audit creation date
  DateTime? dateCreated;

  /// The request URL
  String? url;

  /// The request user agent
  String? userAgent;

  /// The request user type
  String? userType;

  /// The username
  String? username;

  /// The request UUID
  String? uuid;

  /// Creates a new [AuditDTO]
  AuditDTO({
    this.aUserId,
    this.auditId,
    this.countTotal,
    this.deviceId,
    this.ipAddress,
    this.method,
    this.objectId,
    this.objectName,
    this.parameters,
    this.serverResponseCode,
    this.serverResponseMessage,
    this.serviceName,
    this.dateCreated,
    this.url,
    this.userAgent,
    this.userType,
    this.username,
    this.uuid,
  });

  /// Creates a [AuditDTO] from a json
  factory AuditDTO.fromJson(Map<String, dynamic> map) => AuditDTO(
        aUserId: map['a_user_id'],
        auditId: map['audit_id'],
        countTotal: map['count_total'],
        deviceId: map['device_id'],
        ipAddress: map['ip_address'],
        method: map['method'],
        objectId: map['object_id'],
        objectName: map['object_name'],
        parameters: map['parameters'],
        serverResponseCode: map['server_response_code'],
        serverResponseMessage: map['server_response_msg'],
        serviceName: map['service_name'],
        dateCreated: JsonParser.parseDate(map['ts_created']),
        url: map['url'],
        userAgent: map['user_agent'],
        userType: map['user_type'],
        username: map['username'],
        uuid: map['uuid'],
      );

  /// creates a list of [AuditDTO] from a list
  static List<AuditDTO> fromJsonList(List<Map<String, dynamic>> json) =>
      json.map(AuditDTO.fromJson).toList(growable: false);
}
