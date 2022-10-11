import 'dart:collection';

import 'package:flutter/material.dart';

import '../../data_layer/network.dart';
import '../utils.dart';

/// An builder that exposes a way to add the [UserInactiveInterceptor]
/// to the [NetClient].
class AppBuilder extends StatefulWidget {
  /// The [NetClient] used by the application.
  final NetClient netClient;

  /// The application builder.
  final WidgetBuilder builder;

  /// The navigator key.
  final GlobalKey<NavigatorState> navigatorKey;

  /// A list of [FLInterceptor] for the [NetClient].
  final UnmodifiableListView<FLInterceptor> interceptors;

  /// Creates [AppBuilder].
  const AppBuilder({
    Key? key,
    required this.netClient,
    required this.builder,
    required this.navigatorKey,
    required this.interceptors,
  }) : super(key: key);

  @override
  _AppBuilderState createState() => _AppBuilderState();
}

class _AppBuilderState extends State<AppBuilder> {
  @override
  void initState() {
    super.initState();

    _updateInterceptorsKey();

    for (final interceptor in widget.interceptors) {
      widget.netClient.addInterceptor(interceptor);
    }
  }

  @override
  void didUpdateWidget(covariant AppBuilder oldWidget) {
    if (widget.navigatorKey != oldWidget.navigatorKey) {
      _updateInterceptorsKey();
    }
    super.didUpdateWidget(oldWidget);
  }

  /// Updates the interceptors with the latest navigator key.
  void _updateInterceptorsKey() {
    for (final interceptor in widget.interceptors) {
      interceptor.updateNavigatorKey(widget.navigatorKey);
    }
  }

  @override
  Widget build(BuildContext context) => Builder(
        builder: widget.builder,
      );
}
