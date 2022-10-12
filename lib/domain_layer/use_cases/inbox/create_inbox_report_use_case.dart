import '../../abstract_repositories.dart';
import '../../models.dart';

/// Create report use case
class CreateInboxReportUseCase {
  /// InboxReport repository
  final InboxRepositoryInterface _repository;

  /// Default constructor
  CreateInboxReportUseCase({
    required InboxRepositoryInterface repository,
  }) : _repository = repository;

  /// Create a new report
  Future<InboxReport> call(
    String categoryId,
  ) {
    return _repository.createReport(
      categoryId,
    );
  }
}
