import '../../dtos.dart';
import '../../network.dart';

/// A provider that handles API requests related to the registration.
class RegistrationProvider {
  /// The NetClient to use for the network requests.
  final NetClient netClient;

  /// Creates [RegistrationProvider].
  RegistrationProvider({
    required this.netClient,
  });

  /// Registers the customer.
  Future<RegistrationResponseDTO> register({
    required RegistrationDTO dto,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.register,
      method: NetRequestMethods.post,
      data: dto.toJson(),
    );

    return RegistrationResponseDTO.fromJson(response.data);
  }

  /// Finalizes the customer registration.
  Future<RegistrationResponseDTO> finalize({
    required RegistrationDTO dto,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.finalizeRegistration,
      method: NetRequestMethods.post,
      data: dto.toJson(),
    );

    return RegistrationResponseDTO.fromJson(response.data);
  }

  /// Registers the customer.
  Future<AuthenticationResponseDTO> authenticate({
    required AuthenticationDTO dto,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.authenticate,
      method: NetRequestMethods.post,
      data: dto.toJson(),
    );

    return AuthenticationResponseDTO.fromJson(response.data);
  }
}
