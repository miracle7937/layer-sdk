import '../../../domain_layer/abstract_repositories/report/report_repository_interface.dart';
import '../../../domain_layer/models/report/report.dart';
import '../../providers/reports_provider.dart/reports_provider.dart';

/// Report repository impl
class ReportRepository implements ReportRepositoryInterface {
  final ReportsProvider _reportsProvider;

  /// Default constructor
  ReportRepository(this._reportsProvider);

  @override
  Future<Report> createReport(Map<String, dynamic> body) async {
    final reportDto = await _reportsProvider.createReport(body);

    return reportDto.toReport();
  }
}
