import 'dart:convert';

import '../../helpers.dart';

/// Represents a Request item
/// as provided by the infobanking service
class RequestDTO {
  /// Unique identifier for the request item
  final String? id;

  /// The request method of this request
  final String? requestMethod;

  /// User ID of the request maker
  final String? makerId;

  /// Creation date of this request
  final DateTime? creationDate;

  /// JSON String with the request data
  final dynamic body;

  /// The request url of this request
  final String? requestUrl;

  /// Creates a new [RequestDTO] instance
  RequestDTO({
    this.id,
    this.requestMethod,
    this.makerId,
    this.creationDate,
    this.body,
    this.requestUrl,
  });

  /// Creates a new [RequestDTO] instance from a JSON
  factory RequestDTO.fromJson(Map<String, dynamic> map) {
    return RequestDTO(
      id: map['request_id'],
      requestMethod: map['request_method'],
      makerId: map['maker'],
      creationDate: JsonParser.parseDate(map['ts_created']),
      body:
          map['request_body'] != null ? jsonDecode(map['request_body']) : null,
      requestUrl: map['request_url'],
    );
  }

  /// Creates a new [RequestDTO] list instance from a JSON list
  static List<RequestDTO> fromJsonList(List<Map<String, dynamic>> json) {
    return json.map(RequestDTO.fromJson).toList(growable: false);
  }
}
