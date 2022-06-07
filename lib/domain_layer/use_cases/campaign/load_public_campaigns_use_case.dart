import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case for loading public type of campaigns.
class LoadPublicCampaignsUseCase {
  final CampaignRepositoryInterface _repository;

  /// Creates a new [LoadCampaignsUseCase] use case.
  LoadPublicCampaignsUseCase({
    required CampaignRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns an campaign response containing a list of public campaigns.
  ///
  /// The [medium] value is used for getting only the campaigns that
  /// belong to this campaign type.
  /// 
  /// The [target] value is used for getting only the campaigns that
  /// belong to public campaign target.
  /// 
  /// [limit] values are required for paginating the results.
  /// 
  /// The [sortby] value is used for sorting the campaigns that belong to
  /// this.

  Future<CustomerCampaign> call({
    CampaignType? medium,
    CampaignTarget? target,
    bool? read,
    int? limit,
    String? sortby,
    bool? desc,
  }) =>
      _repository.getPublicCampaigns(
        medium: medium!,
        target: target!,
        limit: limit,
        read: read,
        sortby: sortby,
        desc: desc,
      );
}
