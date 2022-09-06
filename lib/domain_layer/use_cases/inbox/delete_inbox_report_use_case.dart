import '../../abstract_repositories.dart';
import '../../models/inbox/inbox_report.dart';

/// Delete report use case
class DeleteInboxReportUseCase {
  /// InboxReport repository
  final InboxRepositoryInterface _repository;

  /// Default constructor
  DeleteInboxReportUseCase({
    required InboxRepositoryInterface repository,
  }) : _repository = repository;

  /// Create a new report
  Future<bool> call(InboxReport report) {
    return _repository.deleteReport(report);
  }
}
