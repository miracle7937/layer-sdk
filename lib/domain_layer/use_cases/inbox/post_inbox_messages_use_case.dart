import 'dart:async';

import 'package:dio/dio.dart';

import '../../../data_layer/dtos.dart';
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
  }) async {
    final requestBody =
        InboxNewMessageDTO(messageText: messageText, reportId: reportId);

    return _repository.postInboxFileList(
      body: requestBody,
      files: [
        for (final f in files)
          await MultipartFile.fromBytes(
            f.fileBinary!,
            filename: f.name,
          ),
      ],
    );
  }
}
