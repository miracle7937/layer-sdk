import '../../abstract_repositories.dart';

/// Use case for using when campaigns open.
class ActionCampaignsUseCase {
  final CampaignRepositoryInterface _repository;

  /// Creates a new [ActionCampaignsUseCase] use case.
  ActionCampaignsUseCase({
    required CampaignRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to send id on campaign action
  Future<void> call({
    int? id,
  }) =>
      _repository.onCampaignOpened(
        id: id!,
      );
}
