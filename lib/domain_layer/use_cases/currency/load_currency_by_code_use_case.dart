import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case for loading a currency by a currency code.
class LoadCurrencyByCodeUseCase {
  final CurrencyRepositoryInterface _repository;

  /// Creates a new [LoadCurrencyByCodeUseCase].
  const LoadCurrencyByCodeUseCase({
    required CurrencyRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns the currency that correspond to the passed currency
  /// code. If not found, it will return `null`.
  Future<Currency?> call({
    required String code,
    bool forceRefresh = false,
  }) =>
      _repository.getCurrencyByCode(
        code: code,
        forceRefresh: forceRefresh,
      );
}
