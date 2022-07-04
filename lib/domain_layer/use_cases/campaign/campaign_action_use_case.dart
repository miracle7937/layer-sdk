import '../../abstract_repositories.dart';

/// The use case that informs the BE analytics service that an action was 
/// triggered on a campaign.
class CampaignActionUseCase {
  final CampaignRepositoryInterface _repository;

  /// Creates a new [ActionCampaignsUseCase] use case.
  CampaignActionUseCase({
    required CampaignRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to send id on campaign action
  Future<void> call({
    required int id,
  }) =>
      _repository.onCampaignOpened(
        id: id,
      );
}
