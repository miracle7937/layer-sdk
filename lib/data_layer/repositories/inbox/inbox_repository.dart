import 'package:dio/dio.dart';

import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Repository for fetching Inbox data
class InboxRepository implements InboxRepositoryInterface {
  /// Reference for [InboxProvider]
  final InboxProvider _provider;

  /// Constructor for [InboxRepository]
  InboxRepository({
    required InboxProvider provider,
  }) : _provider = provider;

  /// Returns a lists of [InboxReport]
  @override
  Future<List<InboxReport>> listAllReports({
    String? searchQuery,
    int? limit,
    int? offset,
  }) async {
    final reports = await _provider.listAllReports(
      limit: limit,
      offset: offset,
      searchQuery: searchQuery,
    );

    return reports.map((r) => r.toInboxReport()).toList();
  }

  /// Creates a new report
  @override
  Future<InboxReportMessage> postNewMessage(
    Map<String, Object> body,
    List<MultipartFile> files,
  ) async {
    final result = await _provider.postMessage(body, files);
    return result.toInboxReportMessage();
  }

  /// Send a new report chat message
  @override
  Future<InboxReportMessage> postChatMessage({
    required int reportId,
    required String messageText,
    String? file,
  }) async {
    final result = await _provider.postChatMessage(
      reportId: reportId,
      messageText: messageText,
      file: file,
    );

    return result.toInboxReportMessage();
  }

  @override
  Future<InboxReportMessage> postInboxFileList({
    required Map<String, Object> body,
    required List<MultipartFile> files,
  }) async {
    final result = await _provider.postInboxFileList(
      body: body,
      files: files,
    );

    return result.toInboxReportMessage();
  }
}
