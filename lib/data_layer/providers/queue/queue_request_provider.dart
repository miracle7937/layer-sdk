import 'package:dio/dio.dart';

import '../../dtos.dart';
import '../../network.dart';

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
    int? limit,
    int? offset,
    bool forceRefresh = true,
  }) async {
    final params = <String, dynamic>{};

    if (limit != null) params['limit'] = limit;
    if (offset != null) params['offset'] = offset;
    params['desc'] = true;
    params['sortBy'] = 'make_ts';

    final response = await netClient.request(
      netClient.netEndpoints.queueRequest,
      method: NetRequestMethods.get,
      queryParameters: params,
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
