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
  /// [limit] values are required for paginating the results.
  ///
  /// The [sortby] value is used for sorting the campaigns that belong to
  /// this.

  Future<CustomerCampaign> call({
    List<CampaignType>? types,
    bool? read,
    int? limit,
    String? sortby,
    bool? desc,
  }) =>
      _repository.list(
        types: types,
        limit: limit,
        read: read,
        sortby: sortby,
        desc: desc,
      );
}
