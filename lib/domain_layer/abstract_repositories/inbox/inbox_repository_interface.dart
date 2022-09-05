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
  Future<InboxReportMessage> postMessage(
    Map<String, Object> body,
    List<MultipartFile> files,
  );
}
