/// Generic exception thrown by the [NetClient]
class NetException implements Exception {
  /// The localized message presentable to the user
  final String? message;

  /// The error details
  final String? details;

  /// The HTTP status code
  final int? statusCode;

  /// Error code
  final String? code;

  /// Creates a new [NetException]
  const NetException({
    this.message,
    this.details,
    this.statusCode,
    this.code,
  });

  /// Creates a new [NetException] from json.
  static NetException? fromJson(
    Map<String, dynamic>? json, {
    int? statusCode,
  }) =>
      json != null
          ? NetException(
              message:
                  json['message'] == null ? null : json['message'].toString(),
              details:
                  json['details'] == null ? null : json['details'].toString(),
              statusCode: statusCode,
              code: json['code'] == null ? null : json['code'].toString())
          : null;

  String toString() => 'NetException: $message'
      ' ${(details?.isNotEmpty ?? false) ? ' - Details: $details' : ''}'
      ' ${statusCode != null ? ' - Status code: $statusCode' : ''}'
      ' ${code != null ? ' - code: $code' : ''}';
}

/// Exception thrown by the [NetClient] that indicates that there was
/// a connectivity error while sending the request.
class ConnectivityException extends NetException {}
