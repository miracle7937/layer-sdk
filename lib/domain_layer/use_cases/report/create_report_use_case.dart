import '../../abstract_repositories/report/report_repository_interface.dart';
import '../../models/report/report.dart';

/// Create report use case
class CreateReportUseCase {
  /// Report repository
  final ReportRepositoryInterface repository;

  /// Default constructor
  CreateReportUseCase(this.repository);

  /// Create a new report
  Future<Report> call(Map<String, dynamic> body) {
    return repository.createReport(body);
  }
}
