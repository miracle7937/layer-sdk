import '../../abstract_repositories.dart';

/// Delete report use case
class DeleteInboxReportUseCase {
  /// InboxReport repository
  final InboxRepositoryInterface _repository;

  /// Default constructor
  DeleteInboxReportUseCase({
    required InboxRepositoryInterface repository,
  }) : _repository = repository;

  /// Create a new report
  Future<void> call(int reportId) {
    return _repository.deleteReport(reportId);
  }
}
