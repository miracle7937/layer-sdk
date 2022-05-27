/// Data transfer object representing response returned from the authentication
/// endpoint.
class AuthenticationResponseDTO {
  /// The id of the authenticated customer.
  String? customerId;

  /// Creates [AuthenticationResponseDTO] from a json map.
  AuthenticationResponseDTO.fromJson(Map<String, dynamic> json)
      : customerId = json['customer_id'];
}
