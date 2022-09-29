import 'dart:async';

import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case for loading all [InboxReport]s.
class LoadAllInboxMessagesUseCase {
  final InboxRepositoryInterface _repository;

  /// Creates a new [LoadAllInboxMessagesUseCase].
  const LoadAllInboxMessagesUseCase({
    required InboxRepositoryInterface repository,
  }) : _repository = repository;

  /// Loads all the [InboxReport]s
  ///
  /// Use the [limit] and [offset] parameters for pagination purposes.
  /// The [query] parameter can be used for filtering the results.
  Future<List<InboxReport>> call({
    String? searchQuery,
    int? limit,
    int? offset,
  }) =>
      _repository.listAllReports(
        searchQuery: searchQuery,
        limit: limit,
        offset: offset,
      );
}
