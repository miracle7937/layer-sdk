import '../../../../data_layer/mappings.dart';
import '../../../../data_layer/network.dart';
import '../../../../data_layer/providers.dart';
import '../../../../domain_layer/models.dart';
import '../../models.dart';
import '../dtos.dart';
import '../mappings.dart';

/// A repository that can be used to register a customer.
class RegistrationRepository {
  final RegistrationProvider _registrationProvider;

  /// Creates [RegistrationRepository].
  RegistrationRepository({
    required RegistrationProvider registrationProvider,
  }) : _registrationProvider = registrationProvider;

  /// Registers the customer.
  ///
  /// The [encryptedCredentials] parameter should be a string encrypted
  /// using the integration key that contains all the sensitive information
  /// that we need to send.
  Future<RegistrationResponse> register({
    required String encryptedCredentials,
    required String encryptionKey,
    String? notificationToken,
    DeviceSession? deviceSession,
  }) async {
    final dto = await _registrationProvider.register(
      dto: RegistrationDTO(
        encryptedCredentials: encryptedCredentials,
        encryptionKey: encryptionKey,
        notificationToken: notificationToken,
        deviceSessionDTO: deviceSession?.toDeviceSessionDTO(),
      ),
    );

    return dto.toRegistrationResponse();
  }

  /// Finalizes the customer registration.
  ///
  /// The [encryptedCredentials] parameter should be a string encrypted
  /// using the integration key that contains all the sensitive information
  /// that we need to send.
  Future<RegistrationResponse> finalize({
    required String encryptedCredentials,
    required String encryptionKey,
    String? notificationToken,
    DeviceSession? deviceSession,
    required String customerId,
    String? otp,
  }) async {
    final dto = await _registrationProvider.finalize(
      dto: RegistrationDTO(
        encryptedCredentials: encryptedCredentials,
        encryptionKey: encryptionKey,
        notificationToken: notificationToken,
        deviceSessionDTO: deviceSession?.toDeviceSessionDTO(),
        customerId: customerId,
        otp: otp,
      ),
    );
    return dto.toRegistrationResponse();
  }

  /// Authenticates the customer and returns the customer id.
  ///
  /// The [encryptedCredentials] parameter should be a string encrypted
  /// using the integration key that contains all the sensitive information
  /// that we need to send.
  Future<String> authenticate({
    required String encryptedCredentials,
    required String encryptionKey,
  }) async {
    final dto = await _registrationProvider.authenticate(
      dto: AuthenticationDTO(
        encryptedCredentials: encryptedCredentials,
        encryptionKey: encryptionKey,
      ),
    );

    if (dto.customerId != null) {
      return dto.customerId!;
    }
    throw NetException(details: 'API response is missing necessary data');
  }
}
