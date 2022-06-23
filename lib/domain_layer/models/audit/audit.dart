import 'package:equatable/equatable.dart';

/// The audit data used by the application
class Audit extends Equatable {
  /// The ID of the user who made the request
  final int? aUserId;

  /// The audit ID
  final int? auditId;

  /// The total count of the audits in the database
  final int? countTotal;

  /// The ID of the device from which the request was made
  final int? deviceId;

  /// The IP address of the device from which the request was made
  final String ipAddress;

  /// The request method
  final String method;

  /// The request object ID
  final String objectId;

  /// The request object name
  final String objectName;

  /// The request parameters
  final String parameters;

  /// The response code
  final String serverResponseCode;

  /// The response message
  final String serverResponseMessage;

  /// The service to which the request was made
  final String serviceName;

  /// The audit creation date
  final DateTime? created;

  /// The request URL
  final String url;

  /// The request user agent
  final String userAgent;

  /// The request user type
  final String userType;

  /// The username
  final String username;

  /// The request UUID
  final String uuid;

  /// The url used to navigate to logs
  final String graphanaUrl;

  ///Creates a new [Audit]
  Audit({
    this.aUserId,
    this.auditId,
    this.countTotal,
    this.deviceId,
    this.ipAddress = '',
    this.method = '',
    this.objectId = '',
    this.objectName = '',
    this.parameters = '',
    this.serverResponseCode = '',
    this.serverResponseMessage = '',
    this.serviceName = '',
    this.created,
    this.url = '',
    this.userAgent = '',
    this.userType = '',
    this.username = '',
    this.uuid = '',
    this.graphanaUrl = '',
  });

  @override
  List<Object?> get props => [
        aUserId,
        auditId,
        countTotal,
        deviceId,
        ipAddress,
        method,
        objectId,
        objectName,
        parameters,
        serverResponseCode,
        serverResponseMessage,
        serviceName,
        created,
        url,
        userAgent,
        userType,
        username,
        uuid,
        graphanaUrl,
      ];

  /// Returns a copy of the audit modified by the provided data.
  Audit copyWith({
    int? aUserId,
    int? auditId,
    int? countTotal,
    int? deviceId,
    String? ipAddress,
    String? method,
    String? objectId,
    String? objectName,
    String? parameters,
    String? serverResponseCode,
    String? serverResponseMessage,
    String? serviceName,
    DateTime? created,
    String? url,
    String? userAgent,
    String? userType,
    String? username,
    String? uuid,
    String? graphanaUrl,
  }) =>
      Audit(
        aUserId: aUserId ?? this.aUserId,
        auditId: auditId ?? this.auditId,
        countTotal: countTotal ?? this.countTotal,
        deviceId: deviceId ?? this.deviceId,
        ipAddress: ipAddress ?? this.ipAddress,
        method: method ?? this.method,
        objectId: objectId ?? this.objectId,
        objectName: objectName ?? this.objectName,
        parameters: parameters ?? this.parameters,
        serverResponseCode: serverResponseCode ?? this.serverResponseCode,
        serverResponseMessage:
            serverResponseMessage ?? this.serverResponseMessage,
        serviceName: serviceName ?? this.serviceName,
        created: created ?? this.created,
        url: url ?? this.url,
        userAgent: userAgent ?? this.userAgent,
        userType: userType ?? this.userType,
        username: username ?? this.username,
        uuid: uuid ?? this.uuid,
        graphanaUrl: graphanaUrl ?? this.graphanaUrl,
      );
}

/// All the fields that can be used to sort the audits in a list.
enum AuditSort {
  /// Creation Date
  date,

  /// Service Name
  serviceName,
}
