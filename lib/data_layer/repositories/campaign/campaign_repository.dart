import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Handles all the campaigns data
class CampaignRepository implements CampaignRepositoryInterface {
  ///The provider
  final CampaignProvider provider;

  /// Creates a new repository with the supplied [CampaignProvider]
  CampaignRepository({
    required this.provider,
  });

  /// Lists the campaigns
  ///
  /// Use cases:
  ///   - Listing the public campaigns on the app.
  ///

  @override
  Future<CampaignResponse> list({
    List<CampaignType>? types,
    bool? read,
    required int limit,
    required int offset,
    String? sortby,
    bool? desc,
  }) async {
    assert(types == null);

    final campaignResponseDTO = await provider.list(
      types: types,
      read: read,
      limit: limit,
      offset: offset,
      sortby: sortby,
      desc: desc,
    );

    return campaignResponseDTO.toCampaignResponse();
  }

  ///Gets an Campaign by its id.
  @override
  Future<CustomerCampaign> getCampaign({
    required int id,
  }) async {
    final campaignDTO = await provider.getCampaign(
      id: id,
    );
    return campaignDTO.toCampaign();
  }

  @override
  Future<CampaignResponse> getPublicCampaigns({
    CampaignType medium = CampaignType.landingPage,
    CampaignTarget target = CampaignTarget.public,
    bool? read,
    required int limit,
    required int offset,
    String? sortby,
    bool? desc,
  }) async {
    final campaignResponseDTO = await provider.getPublicCampaigns(
      medium: medium,
      target: target,
      read: read,
      limit: limit,
      offset: offset,
      sortby: sortby,
      desc: desc,
    );
    return campaignResponseDTO.toCampaignResponse();
  }

  @override
  Future onCampaignAction({
    required int id,
  }) async {
    final campaignDTO = await provider.onCampaignAction(
      id: id,
    );
    return campaignDTO.toCampaign();
  }

  @override
  Future onCampaignOpened({
    required int id,
  }) async {
    final campaignDTO = await provider.onCampaignOpened(
      id: id,
    );
    return campaignDTO.toCampaign();
  }
}
