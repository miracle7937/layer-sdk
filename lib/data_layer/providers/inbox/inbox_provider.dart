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
  ///
  /// [searchQuery] Filter the results based on a search query
  /// [limit] The total number of reports to fetch (Used for pagination)
  /// [offset] The number of reports to skip (Used for pagination)
  Future<List<InboxReportDTO>> listAllReports({
    String? searchQuery,
    int? limit,
    int? offset,
  }) async {
    final params = <String, dynamic>{
      'include_details': true,
    }
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
      fields: {'message_object': body},
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
      method: NetRequestMethods.post,
      data: {
        "report_id": reportId,
        "text": messageText,
        "files": file,
      },
    );

    if (response.data is List) {
      return InboxReportMessageDTO.fromJson(response.data.first);
    }

    return InboxReportMessageDTO.fromJson(response.data);
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

  /// Create a new inbox report
  ///
  /// [categoryId] The category id for the new report
  Future<InboxReportDTO> createReport(
    String categoryId,
  ) async {
    final result = await netClient.request(
      netClient.netEndpoints.report,
      method: NetRequestMethods.post,
      data: {
        'category': categoryId,
      },
    );

    return InboxReportDTO.fromJson(result.data);
  }
}
