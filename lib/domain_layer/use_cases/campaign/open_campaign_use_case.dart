import '../../abstract_repositories.dart';

/// Use case for using when campaigns open.
///
/// This use case will be called when a campaign details are opened
class OpenCampaignsUseCase {
  final CampaignRepositoryInterface _repository;

  /// Creates a new [OpenCampaignsUseCase] use case.
  OpenCampaignsUseCase({
    required CampaignRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to send id when campaign opened
  Future<void> call({
    required int id,
  }) =>
      _repository.onCampaignOpened(
        id: id,
      );
}
