import 'dart:async';

import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case for loading all [InboxReport] categories.
class SendReportChatMessageUseCase {
  final InboxRepositoryInterface _repository;

  /// Creates a new [SendReportChatMessageUseCase].
  const SendReportChatMessageUseCase({
    required InboxRepositoryInterface repository,
  }) : _repository = repository;

  /// Post a new InboxReport
  Future<InboxReportMessage> call({
    required String messageText,
    required int reportId,
    String? fileUrl,
  }) {
    return _repository.postChatMessage(
      messageText: messageText,
      reportId: reportId,
      file: fileUrl,
    );
  }
}
