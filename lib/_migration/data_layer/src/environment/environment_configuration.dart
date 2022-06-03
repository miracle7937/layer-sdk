import 'default_environment_configuration.dart';

/// Representation of all environmental variables used in the data layer.
abstract class EnvironmentConfiguration {
  /// The current configuration of the application.
  ///
  /// The apps should set their configuration as [current] at startup.
  /// The default configuration is provided to allow to kick start projects
  /// before their environment is configured.
  ///
  /// The default configuration does not contain the [experienceAppId],
  /// but you can provide it for the default environment like this:
  /// ```
  /// EnvironmentConfiguration.current = DefaultEnvironmentConfiguration(
  ///   experienceAppId: experienceAppId,
  /// );
  /// ```
  static EnvironmentConfiguration current = DefaultEnvironmentConfiguration();

  /// Unique identifier of the application in the Experience Studio.
  ///
  /// This field is optional and should be set only by the applications
  /// that use the Experience Studio.
  ///
  /// Note that you can't use the [Experience] in the application
  /// if you do not configure this field.
  final String? experienceAppId;

  /// Base url to be used for all API requests.
  final String baseUrl;

  /// Port to be used for all API requests.
  final String port;

  /// Token to be used for public API requests.
  final String defaultToken;

  /// If not null, it will be appended to the baseUrl along with the port
  /// e.g https://[baseUrl]:[port][pathPrefix]
  final String pathPrefix;

  /// The configuration string for the OCRA algorithm.
  ///
  /// It is required for apps that use the OCRA mutual authentication flow.
  /// More information about the OCRA suite can be found here:
  /// https://datatracker.ietf.org/doc/html/rfc6287#section-6
  final String? ocraSuite;

  /// Getter for retrieving the whole url
  String get fullUrl =>
      baseUrl + (port.isNotEmpty ? ':$port' : '') + pathPrefix;

  /// Creates [EnvironmentConfiguration].
  ///
  /// The [experienceAppId] parameter is optional,
  /// but needed for apps that use the Experience Studio.
  EnvironmentConfiguration({
    this.experienceAppId,
    required this.baseUrl,
    this.port = '',
    required this.defaultToken,
    this.pathPrefix = '',
    this.ocraSuite,
  });
}
