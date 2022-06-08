import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../network.dart';

/// A provider that handles API requests related to [CustomerCampaignDTO].
class CampaignProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  ///Creates a new [CampaignProvider]
  const CampaignProvider({
    required this.netClient,
  });

  /// Lists the campaigns.
  ///
  /// Allows for filtering by [CampaignType] and the `read` status.
  /// 
  /// Allows for pagination and sorting. It can sorted based on created time
  /// using [sortby] parameter as `ts_created`.
  ///
  /// The [CampaignTarget] field is used for for filtering to targeted towards 
  /// specific customers or to public.
  /// Use cases:
  ///   - Listing the campaigns on the app.
  ///   - Listing the public campaigns on the app.
  Future<CampaignResponseDTO> list({
    required List<CampaignType> types,
    CampaignTarget? target,
    bool? read,
    int? limit,
    int? offset,
    String? sortby,
    bool? desc,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.campaign,
      method: NetRequestMethods.get,
      queryParameters: {
        if (types.isNotEmpty) 'medium': types.join(','),
        if (target != null) 'target': target,
        if (read != null) 'read': read,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
        if (sortby != null) 'sortby': sortby,
        if (desc != null) 'desc': desc,
      },
    );

    return CampaignResponseDTO.fromJson(response.data);
  }

  ///Gets an Campaign by its id.
  Future<CustomerCampaignDTO> getCampaign({
    required int id,
  }) async {
    final response = await netClient.request(
      '${netClient.netEndpoints.campaign}/$id',
      method: NetRequestMethods.get,
    );

    return CustomerCampaignDTO.fromJson(response.data);
  }

  /// Sends campaign's id on that campaign action
  Future<void> onCampaignAction({
    required int id,
  }) async {
    await netClient.request(
      '${netClient.netEndpoints.campaign}/$id/action',
      method: NetRequestMethods.get,
    );

  }

  /// Sends campaign id when that campaign opened
  Future<void> onCampaignOpened({
    required int id,
  }) async {
    await netClient.request(
      '${netClient.netEndpoints.campaign}/$id/open',
      method: NetRequestMethods.get,
    );
  }
}
