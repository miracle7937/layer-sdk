import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case that loads [Profile] data using the provided `customerID`.
class GetProfileUseCase {
  final ProfileRepositoryInterface _repository;

  /// Creates a new [GetProfileUseCase] instance.
  GetProfileUseCase({
    required ProfileRepositoryInterface repository,
  }) : _repository = repository;

  /// Fetches the [Profile] for the provided [customerID]
  Future<Profile> call({
    required String customerID,
    bool forceRefresh = false,
  }) =>
      _repository.getProfile(
        customerID: customerID,
        forceRefresh: forceRefresh,
      );
}
