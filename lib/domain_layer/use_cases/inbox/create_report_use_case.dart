import 'dart:async';

import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case for loading all [InboxReport] categories.
class CreateReportUseCase {
  final InboxRepositoryInterface _repository;

  /// Creates a new [CreateReportUseCase].
  const CreateReportUseCase({
    required InboxRepositoryInterface repository,
  }) : _repository = repository;

  /// Post a new InboxReport
  Future<InboxReportMessage> call({
    required String description,
    required String categoryId,
    required List<InboxFile> files,
  }) {
    final body = {
      'text': description,
      'report': {
        'category': categoryId,
      }
    };

    return _repository.postNewMessage(body, files);
  }
}
