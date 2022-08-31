import '../../dtos/report/report_dto.dart';
import '../../network.dart';

/// Reports provider
class ReportsProvider {
  final NetClient _netClient;

  /// Default constructor
  ReportsProvider(this._netClient);

  /// Create a new report
  Future<ReportDTO> createReport(Map<String, dynamic> body) async {
    final result = await _netClient.request(_netClient.netEndpoints.report,
        method: NetRequestMethods.post);

    return ReportDTO.fromJson(result.data);
  }
}
