import 'package:layer_sdk/data_layer/data_layer.dart';

/// Represents all environment variables used by in Flutter applications.
class FlutterEnvironmentConfiguration extends EnvironmentConfiguration {
  /// The current environment of the Flutter application.
  static FlutterEnvironmentConfiguration get current =>
      EnvironmentConfiguration.current as FlutterEnvironmentConfiguration;

  /// The path to a public key used for data encryption
  /// for the integration service.
  final String? integrationPublicKey;

  /// The path to the ssl certificate file.
  final String? sslCertificatePath;

  /// Creates [FlutterEnvironmentConfiguration].
  FlutterEnvironmentConfiguration({
    this.integrationPublicKey,
    this.sslCertificatePath,
    String? experienceAppId,
    required String baseUrl,
    String port = '',
    required String defaultToken,
    String pathPrefix = '',
    String? ocraSuite,
  }) : super(
          experienceAppId: experienceAppId,
          baseUrl: baseUrl,
          port: port,
          defaultToken: defaultToken,
          pathPrefix: pathPrefix,
          ocraSuite: ocraSuite,
        );
}
