import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case for loading all type of campaigns.
class LoadCampaignsUseCase {
  final CampaignRepositoryInterface _repository;

  /// Creates a new [LoadCampaignsUseCase] use case.
  LoadCampaignsUseCase({
    required CampaignRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns an campaign response containing a list of campaigns.
  ///
  /// The [types] value is used for getting only the campaigns that
  /// belong to those campaign type list.
  ///
  /// The [target] value is used for getting only the campaigns that
  /// belong to public campaign target.
  ///
  /// [limit] and [offset] values are required for paginating the results.
  ///
  /// The [sortby] value is used for sorting the campaigns that belong to
  /// this.
  Future<CampaignResponse> call({
    List<CampaignType> types = const [
      CampaignType.newsfeed,
      CampaignType.popup
    ],
    CampaignTarget target = CampaignTarget.public,
    bool? read,
    required int limit,
    required int offset,
    String? sortby,
    bool? desc,
  }) =>
      _repository.list(
        types: types,
        target: target,
        limit: limit,
        offset: offset,
        read: read,
        sortby: sortby,
        desc: desc,
      );
}
