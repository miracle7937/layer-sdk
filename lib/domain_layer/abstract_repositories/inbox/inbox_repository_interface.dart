import '../../models.dart';

/// Abstract repository for the Inbox repository
abstract class InboxRepositoryInterface {
  /// Returns a list of all [InboxReport]
  Future<List<InboxReport>> listAllReports({
    String? searchQuery,
    int? limit,
    int? offset,
  });

  /// Create a new [InboxReport]
  ///
  /// [categoryId] The category id for the new report
  Future<InboxReport> createReport(String category);
}
