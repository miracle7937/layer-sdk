import 'package:dio/dio.dart';

import '../../models.dart';

/// Abstract repository for the Inbox repository
abstract class InboxRepositoryInterface {
  /// Returns a list of all [InboxReport]
  Future<List<InboxReport>> listAllReports({
    String? searchQuery,
    int? limit,
    int? offset,
  });

  /// Creates a new [InboxReport]
  ///
  /// Receives a json map containing information about the report
  /// and a list of [InboxFile]s containing files to be sent to the server
  Future<InboxReportMessage> postNewMessage(
    Map<String, Object> body,
    List<InboxFile> files,
  );

  /// Send a new report chat message
  Future<InboxReportMessage> postChatMessage({
    required int reportId,
    required String messageText,
    String? file,
  });

  /// Send a list of [InboxFile] to the server
  Future<InboxReportMessage> postInboxFileList({
    required Map<String, Object> body,
    required List<MultipartFile> files,
  });

  /// Create a new Report
  Future<InboxReport> createReport(String category);
}
