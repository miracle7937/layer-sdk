import 'package:dio/dio.dart';
import 'package:path/path.dart' as path_utils;

import '../../environment.dart';
import '../../models.dart';
import '../../network.dart';

///Handle requests based on configurations
class ConfigInterceptor extends Interceptor {
  ///The app configurations
  final Config config;

  ///The logged in user
  User? _user;

  final ConsoleEndpoints _consoleEndpoints = ConsoleEndpoints();
  final path_utils.Context _pathContext =
      path_utils.Context(style: path_utils.Style.url);

  ///Create a new [ConfigInterceptor]
  ConfigInterceptor({
    required this.config,
  });

  /// Sets the current user
  // ignore: avoid_setters_without_getters
  set user(User user) => _user = user;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (isApiRequest(options.path)) {
      final isMakerChecker =
          ['POST', 'PATCH', 'PUT', 'DELETE'].contains(options.method) &&
              isMakerCheckerApi(options.path);

      if (isMakerChecker && !isWhiteListed(options.path)) {
        final newData = [
          {
            'operation': getOperation(options.method),
            'maker_id': _user?.username,
            'body': options.data
          }
        ];

        final splittedUrlV1 = options.path.split('/v1');

        if (options.path.contains(_consoleEndpoints.infobankingLink)) {
          newData[0]['url'] =
              config.internalServices.infobanking + splittedUrlV1[1];
        }

        if (options.path.contains(_consoleEndpoints.user)) {
          newData[0]['url'] =
              config.internalServices.authCustomer + splittedUrlV1[1];
        }

        options.data = newData;
        options.path = _pathContext.join(
          EnvironmentConfiguration.current.baseUrl,
          _consoleEndpoints.queueRequest,
        );
        options.method = 'POST';
      }
    }
    handler.next(options);
  }

  /// Returns if a given url is an API request
  bool isApiRequest(String url) => [
        _consoleEndpoints.infobankingLink,
        _consoleEndpoints.user,
      ].any(url.contains);

  /// Returns if a given url should be redirected to the maker/checker flow
  bool isMakerCheckerApi(String url) => [
        _consoleEndpoints.infobankingLink,
        _consoleEndpoints.user,
      ].any(url.contains);

  /// Returns if a given url shouldn't be redirected to the maker/checker flow
  bool isWhiteListed(String url) => [
        _consoleEndpoints.officialBankStatement,
        _consoleEndpoints.accountCertificate,
      ].any(url.contains);

  /// Returns the symbol of a given HTTP method
  String getOperation(String method) {
    switch (method) {
      case 'POST':
        return 'O';
      case 'PATCH':
        return 'A';
      case 'DELETE':
        return 'D';
      case 'PUT':
        return 'U';
    }
    return '';
  }
}
