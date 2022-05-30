import 'dart:io';
import 'dart:typed_data';

import 'package:logging/logging.dart';

import '../../../data_layer/data_layer.dart';

/// The default SSL pinning handler implementation.
///
/// It accepts connections to the `EnvironmentConfiguration.current.baseUrl`
/// host only if they signed with the provided certificate. For other hosts
/// all requests are accepted.
///
/// This is a callable class - an instance can be passed directly into
/// the `onHttpClientCreate` field of [NetClient].
class SSLPinningHandler {
  final Logger _logger = Logger('SSLHandler');

  /// The content of the pfx file containing the trusted certificate.
  ///
  /// If it's not provided the implementation will return a default
  /// [HttpClient].
  final ByteData? trustedCertificate;

  /// Creates a new [SSLPinningHandler].
  SSLPinningHandler({
    required this.trustedCertificate,
  });

  /// Returns a [HttpClient] configured to only trust the [trustedCertificate].
  HttpClient? call(HttpClient client) {
    if (trustedCertificate == null) return client;

    final _context = SecurityContext(withTrustedRoots: false);
    _context.setTrustedCertificatesBytes(
      trustedCertificate!.buffer.asUint8List(),
    );

    return HttpClient(context: _context)
      ..badCertificateCallback = _certificateCallback;
  }

  bool _certificateCallback(X509Certificate c, String host, int port) {
    final baseUri = Uri.parse(
      EnvironmentConfiguration.current.baseUrl,
    );

    final sameHost = baseUri.host == host;
    _logger.info('Same host certificate: $sameHost');
    if (sameHost) {
      _logger.severe('Failed to verify server certificate for $host:$port');
      _logger.severe(
        'Make sure to add the correct pfx file to the serverKey in your '
        'environment config.',
      );
    }
    return !sameHost;
  }
}
