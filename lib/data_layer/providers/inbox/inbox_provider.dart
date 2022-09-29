import '../../dtos.dart';
import '../../extensions.dart';
import '../../network.dart';

/// Provider that handles calls to the Inbox endpoint
class InboxProvider {
  /// Handle network calls
  final NetClient netClient;

  /// Creates a new InboxProvider
  const InboxProvider({
    required this.netClient,
  });

  /// Returns a list of all [InboxReportDTO]
  ///
  /// [searchQuery] Filter the results based on a search query
  /// [limit] The total number of reports to fetch (Used for pagination)
  /// [offset] The number of reports to skip (Used for pagination)
  Future<List<InboxReportDTO>> listAllReports({
    String? searchQuery,
    int? limit,
    int? offset,
  }) async {
    final params = <String, dynamic>{}
      ..addIfNotNull('q', searchQuery)
      ..addIfNotNull('limit', limit)
      ..addIfNotNull('offset', offset);

    final response = await netClient.request(
      netClient.netEndpoints.report,
      method: NetRequestMethods.get,
      queryParameters: params,
    );

    return InboxReportDTO.fromJsonList(
        List<Map<String, dynamic>>.from(response.data));
  }

  /// Create a new inbox report
  ///
  /// [categoryId] The category id for the new report
  Future<InboxReportDTO> createReport(
    String categoryId,
  ) async {
    final result = await netClient.request(
      netClient.netEndpoints.report,
      method: NetRequestMethods.post,
      data: {
        'category': categoryId,
      },
    );

    return InboxReportDTO.fromJson(result.data);
  }

  /// Delete report
  Future<bool> deleteReport(InboxReportDTO inboxReport) async {
    final result = await netClient.request(
      "${netClient.netEndpoints.report}/${inboxReport.id}",
      method: NetRequestMethods.delete,
    );

    return result.success;
  }
}
