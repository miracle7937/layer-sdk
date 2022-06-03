import 'package:dio/dio.dart';

import '../../../../data_layer/network.dart';
import '../dtos.dart';

/// Provides data related to [Queue] and [Request]
class QueueRequestProvider {
  /// The Netclient instance to be used for network requests
  final NetClient netClient;

  /// Creates a new [QueueRequestProvider]
  QueueRequestProvider(
    this.netClient,
  );

  /// Retrieves the list of Queues and Requests from the console service
  Future<QueueRequestDTO> list({
    int limit = 50,
    int offset = 0,
    bool forceRefresh = true,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.queueRequest,
      method: NetRequestMethods.get,
      queryParameters: {
        'desc': true,
        'sortBy': 'make_ts',
        'limit': limit,
        'offset': offset,
      },
      forceRefresh: forceRefresh,
    );

    return QueueRequestDTO.fromJson(response.data);
  }

  /// Accepts a [QueueRequest] item
  Future<bool> accept(
    String requestId, {
    required bool isRequest,
  }) async {
    final endpointUrl = isRequest
        ? '${netClient.netEndpoints.requests}/$requestId/approve'
        : '${netClient.netEndpoints.queueRequest}/$requestId/approve';

    final response = await netClient.request(
      endpointUrl,
      method: NetRequestMethods.post,
      responseType: ResponseType.plain,
      decodeResponse: false,
      throwAllErrors: false,
    );

    return response.success;
  }

  /// Rejects a [QueueRequest] item
  Future<bool> reject(
    String requestId, {
    required bool isRequest,
  }) async {
    final endpointUrl = isRequest
        ? '${netClient.netEndpoints.requests}/$requestId/reject'
        : '${netClient.netEndpoints.queueRequest}/$requestId/reject';

    final response = await netClient.request(
      endpointUrl,
      method: NetRequestMethods.post,
      decodeResponse: false,
      throwAllErrors: false,
    );

    return response.success;
  }
}
