import 'package:flutter/material.dart';

/// A class containing all the necessary parameters
/// for the navigation configuration.
abstract class AppNavigationConfiguration {
  /// The first route to be displayed when the application launches.
  String get initialRoute;

  /// The route generator callback used when the app
  /// is navigated to a named route.
  Route onGenerateRoute(RouteSettings settings);
}
