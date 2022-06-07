import '../../models.dart';

/// An abstract repository for the campaigns.
abstract class CampaignRepositoryInterface {
  /// Paginates a list of the campaigns.
  Future<CampaignResponse> list({
    List<CampaignType>? types,
    bool? read,
    required int limit,
    required int offset,
    String? sortby,
    bool? desc,
  });

  /// Gets an [CustomerCampaign] by its id.
  Future<CustomerCampaign> getCampaign({
    required int id,
  });

  ///Gets public campaigns that is public in [CampaignTarget]
  Future<CampaignResponse> getPublicCampaigns({
    CampaignType medium = CampaignType.landingPage,
    CampaignTarget target = CampaignTarget.public,
    bool? read,
    required int limit,
    required int offset,
    String? sortby,
    bool? desc,
  });

  /// Send id on campaign action
  Future<void> onCampaignOpened({
    required int id,
  });

  /// Send id when campaign opened
  Future<void> onCampaignAction({
    required int id,
  });
}
