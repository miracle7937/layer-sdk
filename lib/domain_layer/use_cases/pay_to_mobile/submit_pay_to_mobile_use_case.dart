import '../../abstract_repositories.dart';
import '../../models.dart';

/// The use case responsible for submiting a new pay to mobile element.
class SubmitPayToMobileUseCase {
  final PayToMobileRepositoryInterface _repository;

  /// Creates new [SubmitPayToMobileUseCase].
  SubmitPayToMobileUseCase({
    required PayToMobileRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns the resulting pay to mobile object from submiting a new pay to
  /// mobile element.
  Future<PayToMobile> call({
    required NewPayToMobile newPayToMobile,
  }) =>
      _repository.submit(
        newPayToMobile: newPayToMobile,
      );
}
