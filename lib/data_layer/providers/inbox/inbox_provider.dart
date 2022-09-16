import 'package:dio/dio.dart';

import '../../dtos.dart';
import '../../extensions.dart';
import '../../network.dart';

/// Provider that handles calls to the Inbox endpoint
class InboxProvider {
  /// Handle network calls
  final NetClient netClient;

  /// Creates a new InboxProvider
  const InboxProvider({
    required this.netClient,
  });

  /// Returns a list of all [InboxReportDTO]
  Future<List<InboxReportDTO>> listAllReports({
    String? searchQuery,
    int? limit,
    int? offset,
  }) async {
    final params = <String, dynamic>{}
      ..addIfNotNull('q', searchQuery)
      ..addIfNotNull('limit', limit)
      ..addIfNotNull('offset', offset);

    final response = await netClient.request(
      netClient.netEndpoints.report,
      method: NetRequestMethods.get,
      queryParameters: params,
    );

    return InboxReportDTO.fromJsonList(
        List<Map<String, dynamic>>.from(response.data));
  }

  /// Posts a Inbox message
  Future<InboxReportMessageDTO> postMessage(
    Map<String, Object> body,
    List<MultipartFile> files,
  ) async {
    final response = await netClient.multipartRequest(
      netClient.netEndpoints.inboxMessage,
      method: NetRequestMethods.post,
      fields: body,
      files: files,
    );

    return InboxReportMessageDTO.fromJson(response.data);
  }

  /// Posts a report chat message
  Future<InboxReportMessageDTO> postChatMessage({
    required int reportId,
    required String messageText,
    required String? file,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.reportMessage,
      data: {
        "report_id": reportId,
        "text": messageText,
        "files": file,
      },
    );

    return InboxReportMessageDTO.fromJson(response.data.first);
  }

  /// Posts a list of
  Future<InboxReportMessageDTO> postInboxFileList({
    required Map<String, Object> body,
    required List<MultipartFile> files,
  }) async {
    final response = await netClient.multipartRequest(
      netClient.netEndpoints.inboxMessage,
      fields: {'message_object': body},
      files: files,
    );

    if (response.data is List) {
      return InboxReportMessageDTO.fromJson(response.data.first);
    }
    return InboxReportMessageDTO.fromJson(response.data);
  }
}
