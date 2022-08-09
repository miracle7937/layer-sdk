import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case for loading all the currencies.
class LoadAllCurrenciesUseCase {
  final CurrencyRepositoryInterface _repository;

  /// Creates a new [LoadAllCurrenciesUseCase].
  const LoadAllCurrenciesUseCase({
    required CurrencyRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns a list containing all the currencies.
  Future<List<Currency>> call({
    bool forceRefresh = false,
    bool onlyVisible = true,
  }) =>
      _repository.list(
        forceRefresh: forceRefresh,
        onlyVisible: onlyVisible,
      );
}
