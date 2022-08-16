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
  ///
  /// Use the [limit] and [offset] parameters for pagination purposes.
  ///
  /// The [query] parameter can be used for filtering the results.
  Future<List<Bank>> call({
    required String countryCode,
    int? limit,
    int? offset,
    String? query,
    bool forceRefresh = false,
  }) =>
      _repository.listByCountryCode(
        countryCode: countryCode,
        limit: limit,
        offset: offset,
        query: query,
        forceRefresh: forceRefresh,
      );
}
