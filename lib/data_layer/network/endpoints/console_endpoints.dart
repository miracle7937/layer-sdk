import 'net_endpoints.dart';

/// A [NetEndpoints] specific for applications that access the console.
class ConsoleEndpoints extends NetEndpoints {
  static const String _authEngine = 'auth-engine';
  static const String _automation = '/automation';
  static const String _consoleAAA = '/console-aaa';
  static const String _console = 'admin/console';
  static const String _customer = '/customer-aaa';
  static const String _developer = '/developer-aaa';

  /// The internal request URL used by some requests like change_status on the
  /// auth-engine.
  ///
  /// TODO: this will be removed when the configuration file is ready.
  final String internalRequestURL;

  /// Creates [ConsoleEndpoints].
  ///
  /// It allows for the customization of the [internalRequestURL], if needed.
  const ConsoleEndpoints({
    this.internalRequestURL = 'http://customer-aaa.usl:8000',
  });

  @override
  String get login => '$_consoleAAA/v1/login';

  @override
  String get permissionModule => '$_consoleAAA/v1/module';

  @override
  String get forgotPassword => '$_consoleAAA/v1/password_forgot';

  @override
  String get resetPassword => '$_consoleAAA/v1/password_change';

  @override
  String get changePassword => '$_consoleAAA/v1/password_change';

  @override
  String get queueRequest => '$_console/v1/queue';

  @override
  String get requests => '$_consoleAAA/v1/request';

  @override
  String get device => '$_consoleAAA/v1/device';

  @override
  String get tasksUser => '$_automation/v1/user_task';

  /// The request change endpoint.
  ///
  /// TODO: this will be removed when the configuration file is ready.
  String requestChange({
    required String userId,
  }) =>
      '$_customer/v2/user/$userId/change_status';

  /// Endpoint for the customer user on the auth-engine.
  ///
  /// TODO: this will be removed when the configuration file is ready.
  String authEngineCustomer({
    required String userId,
  }) =>
      '$_authEngine/v2/user/$userId';

  /// Endpoint for the reset user PIN on the auth-engine.
  ///
  /// TODO: this will be removed when the configuration file is ready.
  String authEngineResetPIN({
    required String userId,
  }) =>
      '$_authEngine/v1/request_reset_txn_pin/$userId';

  /// Endpoint for the console user transaction PIN reset request.
  String get resetUserPIN => '$_customer/v1/reset_txn_pin';

  @override
  String get verifyDeviceLogin => '$_consoleAAA/v1/verify_device_login';

  /// The developer user endpoint.
  String get developerUser => '$_developer/v1/user';
}
