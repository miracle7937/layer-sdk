import 'dart:async';

import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case for posting a list of [InboxFile].
class PostInboxFilesUseCase {
  final InboxRepositoryInterface _repository;

  /// Creates a new [PostInboxFilesUseCase].
  const PostInboxFilesUseCase({
    required InboxRepositoryInterface repository,
  }) : _repository = repository;

  /// Post a new InboxReport
  Future<InboxReportMessage> call({
    required int reportId,
    required List<InboxFile> files,
    required String messageText,
  }) {
    final requestBody = {
      "report_id": reportId,
      "text": messageText,
    };

    return _repository.postInboxFileList(
      body: requestBody,
      files: files.map((f) => f.toMultipartFile()).toList(),
    );
  }
}
