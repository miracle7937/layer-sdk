import '../../dtos.dart';
import '../../extensions/map/map_extensions.dart';
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

    return InboxReportDTO.fromJsonList(response.data);
  }
}
