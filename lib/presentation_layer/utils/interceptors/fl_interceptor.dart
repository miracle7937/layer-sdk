import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// This wrapper grants the dio interceptors the ability to access the current
/// context by exposing a method for updating the [NavigatorState] key.
abstract class FLInterceptor extends Interceptor {
  /// The [NavigatorState] key.
  late GlobalKey<NavigatorState> _navigatorKey;

  /// Updates the [NavigatorState] key.
  // ignore: use_setters_to_change_properties
  void updateNavigatorKey(GlobalKey<NavigatorState> key) => _navigatorKey = key;

  /// A getter for the current [BuildContext].
  BuildContext get context => _navigatorKey.currentContext!;
}
