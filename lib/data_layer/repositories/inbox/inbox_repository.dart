import 'package:dio/dio.dart';

import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../dtos.dart';
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
    InboxNewReportDTO body,
    List<InboxFile> files,
  ) async {
    final result = await _provider.postMessage(body, [
      for (final f in files)
        await MultipartFile.fromBytes(
          f.fileBinary!,
          filename: f.name,
        ),
    ]);
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
    required InboxNewMessageDTO body,
    required List<MultipartFile> files,
  }) async {
    final result = await _provider.postInboxFileList(
      body: body,
      files: files,
    );

    return result.toInboxReportMessage();
  }

  /// Create a new [InboxReport]
  ///
  /// [categoryId] The category id for the new report
  @override
  Future<InboxReport> createReport(
    String categoryId,
  ) async {
    final reportDto = await _provider.createReport(
      categoryId,
    );
    return reportDto.toInboxReport();
  }
}
