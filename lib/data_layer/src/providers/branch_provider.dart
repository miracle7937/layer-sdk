import '../../network.dart';
import '../dtos.dart';

/// A provider that handles API requests related to branches.
class BranchProvider {
  /// The [NetClient] to use for the network requests.
  final NetClient netClient;

  /// Creates a [BranchProvider].
  const BranchProvider({
    required this.netClient,
  });

  /// Lists the branches.
  Future<List<BranchDTO>> list({
    bool forceRefresh = false,
    double? lat,
    double? long,
    int? limit,
    int? offset,
    String? searchQuery,
  }) async {
    final params = <String, dynamic>{};

    if (lat != null) params['latitude'] = lat;
    if (long != null) params['longitude'] = long;
    if (limit != null) params['limit'] = limit;
    if (offset != null) params['offset'] = offset;
    if (searchQuery != null) params['q'] = searchQuery;

    final response = await netClient.request(
      netClient.netEndpoints.branch,
      forceRefresh: forceRefresh,
      queryParameters: params,
    );

    return BranchDTO.fromJsonList(response.data);
  }

  /// Return a branch by its id
  Future<BranchDTO> fetchBranchById(String branchId) async {
    final response = await netClient.request(
      "${netClient.netEndpoints.branch}/$branchId",
      method: NetRequestMethods.get,
      forceRefresh: false,
    );

    return BranchDTO.fromJson(response.data);
  }
}
