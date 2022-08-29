import 'dart:async';

import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case for loading all loyalty points.
class ListAllInboxMessagesUseCase {
  final InboxRepositoryInterface _repository;

  /// Creates a new [LoadAllLoyaltyPointsUseCase].
  const ListAllInboxMessagesUseCase({
    required InboxRepositoryInterface repository,
  }) : _repository = repository;

  /// Loads all the loyalty points
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
