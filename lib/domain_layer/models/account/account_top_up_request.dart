import 'package:equatable/equatable.dart';

/// Holds the account top up request data.
class AccountTopUpRequest extends Equatable {
  /// The client secret used by the stripe sdk.
  final String clientSecret;

  /// The ID of the top up request.
  final String id;

  /// Creates a new [AccountTopUpRequest] instance.
  AccountTopUpRequest({
    this.clientSecret = '',
    this.id = '',
  });

  @override
  List<Object> get props => [
        clientSecret,
        id,
      ];

  /// Creates a copy of a [AccountTopUpRequest] with the provided parameters.
  AccountTopUpRequest copyWith({
    String? clientSecret,
    String? id,
  }) {
    return AccountTopUpRequest(
      clientSecret: clientSecret ?? this.clientSecret,
      id: id ?? this.id,
    );
  }
}
