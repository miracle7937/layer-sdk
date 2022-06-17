import 'package:flutter/material.dart';

/// A class that holds the SSL configurations of the app
class AppSSLConfiguration {
  /// Stream for listening to certificate state when its is invalid
  /// [SSLCertificateState.bad]
  final Stream<SSLCertificateState> invalidSSLCertificateStream;

  /// If [invalidSSLCertificateStream] is provided, and it has
  /// [SSLCertificateState.bad] value, this callback will be called with a
  /// proper build context for showing the required error
  final ValueChanged<BuildContext> onInvalidSSLCertificate;

  /// Create [AppSSLConfiguration]
  AppSSLConfiguration({
    required this.invalidSSLCertificateStream,
    required this.onInvalidSSLCertificate,
  });
}

/// Enum to specify the certificate state
enum SSLCertificateState {
  /// When the certificate is invalid
  invalid,

  /// When the certificate is ok
  ok,
}
