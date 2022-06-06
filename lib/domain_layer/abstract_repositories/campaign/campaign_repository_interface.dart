import '../../models.dart';

/// An abstract repository for the campaigns.
abstract class CampaignRepositoryInterface {
  /// Paginates a list of the campaigns.
  Future<CustomerCampaign> list({
    List<CampaignType>? types,
    bool? read,
    int? limit,
    String? sortby,
    bool? desc,
  });

  /// Gets an [CustomerCampaign] by its id.
  Future<CustomerCampaign> getCampaign({
    required int id,
    bool? read,
    int? limit,
    String? sortby,
    bool? desc,
  });

  ///Gets public campaigns that is public in [CampaignTarget]
  Future<List<CustomerCampaign>> getPublicCampaigns({
    CampaignType medium = CampaignType.landingPage,
    CampaignTarget target = CampaignTarget.public,
    bool? read,
    int? limit,
    String? sortby,
    bool? desc,
  });

  /// 
  Future<dynamic> onCampaignOpened({
    required int id,
  });

  ///
  Future<dynamic> onCampaignAction({
    required int id,
  });
}
