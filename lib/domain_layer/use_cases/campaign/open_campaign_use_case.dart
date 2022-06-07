import '../../abstract_repositories.dart';

/// Use case for using when campaigns open.
class OpenCampaignsUseCase {
  final CampaignRepositoryInterface _repository;

  /// Creates a new [OpenCampaignsUseCase] use case.
  OpenCampaignsUseCase({
    required CampaignRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to send id when campaign opened
  Future<void> call({
    int? id,
  }) =>
      _repository.onCampaignOpened(
        id: id!,
      );
}
