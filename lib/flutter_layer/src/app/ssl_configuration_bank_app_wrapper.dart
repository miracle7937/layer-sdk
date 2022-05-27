import 'dart:async';

import 'package:flutter/material.dart';
import 'app_ssl_configuration.dart';

/// Wrapper for [BankApp] to provide the needed for
/// ssl configurations
class SSLConfigurationBankAppWrapper extends StatefulWidget {
  /// Object that holds all the ssl configurations needed
  final AppSSLConfiguration? appSSLConfiguration;

  /// Child app we need are wrapping
  final Widget child;

  /// The [NavigatorState] key that holds the current context
  final GlobalKey<NavigatorState> navigatorKey;

  /// Create [SSLConfigurationBankAppWrapper]
  const SSLConfigurationBankAppWrapper({
    Key? key,
    required this.child,
    required this.navigatorKey,
    this.appSSLConfiguration,
  }) : super(key: key);

  @override
  _SSLConfigurationBankAppWrapperState createState() =>
      _SSLConfigurationBankAppWrapperState();
}

class _SSLConfigurationBankAppWrapperState
    extends State<SSLConfigurationBankAppWrapper> {
  StreamSubscription? _subscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.appSSLConfiguration != null && _subscription == null) {
      _subscription = widget.appSSLConfiguration!.invalidSSLCertificateStream
          .listen((event) {
        if (event == SSLCertificateState.invalid) {
          widget.appSSLConfiguration!
              .onInvalidSSLCertificate(widget.navigatorKey.currentContext!);
          // Cancel listening to [invalidCertificateStream] after
          // we get the first value as [CertificateState.invalid]
          _subscription!.cancel();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
