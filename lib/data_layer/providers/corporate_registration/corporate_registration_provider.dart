import 'package:dio/dio.dart';
import 'package:path/path.dart' as path_utils;

import '../../dtos.dart';
import '../../environment.dart';
import '../../network.dart';

/// A provider that handles API requests related to the corporate registration.
class CorporateRegistrationProvider {
  /// The NetClient to use for the network requests.
  final NetClient netClient;

  /// Creates [CorporateRegistrationProvider].
  CorporateRegistrationProvider({
    required this.netClient,
  });

  /// Registers the corporate customer.
  Future<List<QueueDTO>> registerCorporate({
    required CorporateRegistrationDTO dto,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.registerCorporate,
      method: NetRequestMethods.post,
      data: dto.toJson(),
    );

    if (response.data is List) {
      return QueueDTO.fromJsonList(
        List<Map<String, dynamic>>.from(response.data),
      );
    }

    throw Exception('Corporate not being registered');
  }

  /// Register user with the data of passed [AgentCreationDTO].
  /// Is used to register new corporate agent.
  ///
  /// Used only by the DBO app.
  Future<QueueDTO> registerAgent({
    required UserDTO dto,
    bool isEditing = false,
  }) async {
    final _pathContext = path_utils.Context(style: path_utils.Style.url);
    final consoleEndpoints = netClient.netEndpoints as ConsoleEndpoints;

    final interceptor = netClient.configInterceptor;
    if (interceptor == null) {
      throw Exception('Agent not being registered');
    }

    final agentUrl = _getAgentCreationUrl(
      internalServicesPath: interceptor.config.internalServices.authCustomer,
      consoleEndpoint: consoleEndpoints.authEngineUser,
      additionalQueryParameters: {'corporate': true},
    );
    final visibilityUrl = _getAgentCreationUrl(
      internalServicesPath: interceptor.config.internalServices.infobanking,
      consoleEndpoint: consoleEndpoints.acl,
    );

    final registerAgentData = [
      await _getQueueData(
        url: agentUrl,
        interceptor: interceptor,
        body: [dto.toAgentJson(isEditing: isEditing)],
        isEditing: isEditing,
      ),
      if ((dto.visibleCards?.isNotEmpty ?? false) ||
          (dto.visibleAccounts?.isNotEmpty ?? false))
        await _getQueueData(
          url: visibilityUrl,
          interceptor: interceptor,
          body: dto.toAccountVisibilityJson(),
          isEditing: isEditing,
        ),
    ];

    final path = _pathContext.join(
      EnvironmentConfiguration.current.baseUrl,
      ConsoleEndpoints().queueRequest,
    );

    final response = await netClient.request(
      path,
      method: NetRequestMethods.post,
      data: registerAgentData,
      addLanguage: false,
    );

    if (response.data is List && response.data.length > 0) {
      return QueueDTO.fromJson(response.data[0]);
    }

    throw Exception('Agent not being registered');
  }

  String _getAgentCreationUrl({
    required String internalServicesPath,
    required String consoleEndpoint,
    Map<String, dynamic>? additionalQueryParameters,
  }) {
    final requestOptions = RequestOptions(
      path: internalServicesPath + consoleEndpoint.split('/v1')[1],
      queryParameters: additionalQueryParameters == null
          ? {'customer_type': 'C'}
          : ({'customer_type': 'C'}..addAll(additionalQueryParameters)),
    );
    return requestOptions.uri.toString();
  }

  Future<Map<String, Object?>> _getQueueData({
    required String url,
    required ConfigInterceptor interceptor,
    required Object body,
    bool isEditing = false,
  }) async =>
      {
        'url': url,
        'operation': interceptor.getOperation(
          isEditing
              ? NetRequestMethods.patch.name
              : NetRequestMethods.post.name,
        ),
        'maker_id': interceptor.user?.username,
        'body': await NetJson().encode(body),
      };
}
