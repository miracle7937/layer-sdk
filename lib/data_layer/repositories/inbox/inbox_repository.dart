import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
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

  @override
  Future<bool> deleteReport(InboxReport inboxReport) {
    return _provider.deleteReport(inboxReport.toInboxReportDTO());
  }
}
