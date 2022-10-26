import 'dart:async';

import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case for loading all [InboxReport] categories.
class LoadAllInboxReportCategoriesUseCase {
  final MessageRepositoryInterface _repository;

  /// Creates a new [LoadAllInboxReportCategoriesUseCase].
  const LoadAllInboxReportCategoriesUseCase({
    required MessageRepositoryInterface repository,
  }) : _repository = repository;

  /// Loads all the [InboxReport] categories
  Future<List<Message>> call() {
    return _repository.getMessages(module: 'report_category');
  }
}
