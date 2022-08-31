import '../../models.dart';

/// Abstract repository for the Inbox repository
abstract class InboxRepositoryInterface {
  /// Returns a list of all [InboxReport]
  Future<List<InboxReport>> listAllReports({
    String? searchQuery,
    int? limit,
    int? offset,
  });

  /// Create a new Report
  Future<InboxReport> createReport(String category);
}
