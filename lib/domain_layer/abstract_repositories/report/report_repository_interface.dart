import '../../models/report/report.dart';

/// Report repository
abstract class ReportRepositoryInterface {
  /// Create report
  Future<Report> createReport(Map<String, dynamic> body);
}
