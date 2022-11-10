import 'package:dio/dio.dart';

import '../../../data_layer/dtos.dart';
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
    InboxNewReportDTO body,
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
    required InboxNewMessageDTO body,
    required List<MultipartFile> files,
  });

  /// Create a new [InboxReport]
  ///
  /// [categoryId] The category id for the new report
  Future<InboxReport> createReport(String category);

  /// Delete report
  Future<bool> deleteReport(InboxReport inboxReport);

  /// Mark a [InboxReport] as read
  Future<InboxReport> markReportAsRead(InboxReport report);
}
