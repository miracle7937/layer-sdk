import 'package:equatable/equatable.dart';

/// The usual response from the NetClient
class NetResponse extends Equatable {
  /// The request result data
  final dynamic data;

  /// Convenience property to indicate that the response code was a 200.
  final bool success;

  /// The HTTP status code
  final int? statusCode;

  /// The HTTP status message
  final String? statusMessage;

  /// Creates a new NetResponse
  NetResponse({
    this.data,
    this.statusCode,
    this.statusMessage,
  }) : success = statusCode?.toString().startsWith('2') ?? false;

  @override
  List<Object?> get props => [
        data,
        success,
        statusCode,
        statusMessage,
      ];
}
