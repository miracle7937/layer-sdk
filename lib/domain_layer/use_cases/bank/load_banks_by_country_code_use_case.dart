import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case responsible for loading banks based on a country code.
class LoadBanksByCountryCodeUseCase {
  final BankRepositoryInterface _repository;

  /// Creates a new [LoadBanksByCountryCodeUseCase] instance.
  const LoadBanksByCountryCodeUseCase({
    required BankRepositoryInterface repository,
  }) : _repository = repository;

  /// Lists banks based on a country code.
  Future<List<Bank>> call({
    required String countryCode,
    bool forceRefresh = false,
  }) =>
      _repository.listByCountryCode(
        countryCode: countryCode,
        forceRefresh: forceRefresh,
      );
}
