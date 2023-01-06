import 'package:dio/dio.dart';
import 'package:path/path.dart' as path_utils;

import '../../domain_layer/models.dart';
import '../environment.dart';
import '../network.dart';

///Handle requests based on configurations
class ConfigInterceptor extends Interceptor {
  ///The app configurations
  final Config config;

  ///The logged in user
  User? user;

  final ConsoleEndpoints _consoleEndpoints = ConsoleEndpoints();
  final path_utils.Context _pathContext =
      path_utils.Context(style: path_utils.Style.url);

  ///Create a new [ConfigInterceptor]
  ConfigInterceptor({required this.config});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (isMakerCheckerApi(options.path)) {
      final isMakerChecker =
          ['POST', 'PATCH', 'PUT', 'DELETE'].contains(options.method) &&
              isMakerCheckerApi(options.path);

      if (isMakerChecker && !isWhiteListed(options.path)) {
        final newData = [
          {
            'operation': getOperation(options.method),
            'maker_id': user?.username,
            'body': options.data
          }
        ];

        final splitUrlV1 = options.uri.toString().split('/v1');

        if (options.path.contains(_consoleEndpoints.infobankingLink)) {
          newData[0]['url'] =
              config.internalServices.infobanking + splitUrlV1[1];
        } else if (options.path.contains(_consoleEndpoints.user) ||
            options.path.contains(_consoleEndpoints.authEngineUser)) {
          newData[0]['url'] =
              config.internalServices.authCustomer + splitUrlV1[1];
        } else if (options.path.contains(_consoleEndpoints.transferLimits)) {
          newData[0]['url'] =
              config.internalServices.txnbanking + splitUrlV1[1];
        }

        options.data = newData;
        options.path = _pathContext.join(
          EnvironmentConfiguration.current.baseUrl,
          _consoleEndpoints.queueRequest,
        );
        options.method = 'POST';
        options.queryParameters = {};
      }
    }
    handler.next(options);
  }

  /// Returns if a given url should be redirected to the maker/checker flow
  bool isMakerCheckerApi(String url) => [
        _consoleEndpoints.infobankingLink,
        _consoleEndpoints.user,
        _consoleEndpoints.authEngineUser,
        _consoleEndpoints.transferLimits,
        _consoleEndpoints.acl,
      ].any(url.contains);

  /// Returns if a given url shouldn't be redirected to the maker/checker flow
  bool isWhiteListed(String url) => [
        _consoleEndpoints.officialBankStatement,
        _consoleEndpoints.accountCertificate,
        _consoleEndpoints.internationalBeneficiary,
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
