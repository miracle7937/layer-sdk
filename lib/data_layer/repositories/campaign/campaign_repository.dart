import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Handles all the campaigns data
class CampaignRepository implements CampaignRepositoryInterface {
  ///The provider
  final CampaignProvider _provider;

  /// Creates a new repository with the supplied [CampaignProvider]
  CampaignRepository({
    required CampaignProvider provider,
  }) : _provider = provider;

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
  @override
  Future<CampaignResponse> list({
    List<CampaignType> types = const [
      CampaignType.newsfeed,
      CampaignType.popup
    ],
    CampaignTarget target = CampaignTarget.public,
    bool? read,
    int? limit,
    int? offset,
    String? sortby,
    bool? desc,
  }) async {
    final campaignResponseDTO = await _provider.list(
      types: types,
      target: target,
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
    final campaignDTO = await _provider.getCampaign(
      id: id,
    );
    return campaignDTO.toCampaign();
  }

  @override
  Future<void> onCampaignAction({
    required int id,
  }) async {
    await _provider.onCampaignAction(
      id: id,
    );
  }

  @override
  Future<void> onCampaignOpened({
    required int id,
  }) async {
    await _provider.onCampaignOpened(
      id: id,
    );
  }
}
