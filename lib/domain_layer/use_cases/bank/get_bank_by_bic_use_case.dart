import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case responsible for loading the bank with the corresponding
/// swift code
class GetBankByBicUseCase {
  final BankRepositoryInterface _repository;

  /// Creates a new [LoadBanksByCountryCodeUseCase] instance.
  const GetBankByBicUseCase({
    required BankRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns the bank with the corresponding
  /// swift code
  Future<Bank> call({
    required String bic,
    bool forceRefresh = false,
  }) =>
      _repository.getBankByBIC(
        bic: bic,
        forceRefresh: forceRefresh,
      );
}
