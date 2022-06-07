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

  /// Lists the campaigns
  ///
  /// Use cases:
  ///   - Listing the public campaigns on the app.
  ///
  Future<CampaignResponseDTO> list({
    List<CampaignType>? types,
    bool? read,
    int? limit,
    int? offset,
    String? sortby,
    bool? desc,
  }) async {
    assert(limit == null && types == null);

    final response = await netClient.request(
      netClient.netEndpoints.campaign,
      method: NetRequestMethods.get,
      queryParameters: {
        if (types != null && types.isNotEmpty) 'medium': types.join(','),
        if (read != null) 'read': read,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
        if (sortby != null) 'sortby': sortby,
        if (desc != null) 'desc': desc,
      },
    );

    return CampaignResponseDTO.fromJson(response.data);
  }

  /// Lists public campaigns
  ///
  Future<CampaignResponseDTO> getPublicCampaigns({
    CampaignType medium = CampaignType.landingPage,
    CampaignTarget target = CampaignTarget.public,
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

  ///Gets an Campaign by its id.
  Future<CustomerCampaignDTO> onCampaignAction({
    required int id,
  }) async {
    final response = await netClient.request(
      '${netClient.netEndpoints.campaign}/$id/action',
      method: NetRequestMethods.get,
    );

    return CustomerCampaignDTO.fromJson(response.data);
  }

  ///Gets an Campaign by its id.
  Future<CustomerCampaignDTO> onCampaignOpened({
    required int id,
  }) async {
    final response = await netClient.request(
      '${netClient.netEndpoints.campaign}/$id/open',
      method: NetRequestMethods.get,
    );

    return CustomerCampaignDTO.fromJson(response.data);
  }
}
