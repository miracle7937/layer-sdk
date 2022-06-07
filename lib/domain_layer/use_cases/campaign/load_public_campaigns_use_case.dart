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
  /// [limit] and [offset] values are required for paginating the results.
  ///
  /// The [sortby] value is used for sorting the campaigns that belong to
  /// this.

  Future<CampaignResponse> call({
    CampaignType? medium,
    CampaignTarget? target,
    bool? read,
    required int limit,
    required int offset,
    String? sortby,
    bool? desc,
  }) =>
      _repository.getPublicCampaigns(
        medium: medium!,
        target: target!,
        limit: limit,
        offset: offset,
        read: read,
        sortby: sortby,
        desc: desc,
      );
}
