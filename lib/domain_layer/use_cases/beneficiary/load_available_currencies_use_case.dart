import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case responsible for loading available currencies
/// when user is adding new beneficiary.
class LoadAvailableCurrenciesUseCase {
  final CurrencyRepositoryInterface _currencyRepository;

  /// Creates a new [LoadAvailableCurrenciesUseCase] instance.
  const LoadAvailableCurrenciesUseCase({
    required CurrencyRepositoryInterface currencyRepository,
  }) : _currencyRepository = currencyRepository;

  /// Lists the available currencies.
  Future<List<Currency>> call({
    bool forceRefresh = false,
  }) async {
    final currencies = await _currencyRepository.getAvailable(
      forceRefresh: forceRefresh,
    );
    return currencies
        .where((currency) =>
            (currency.code?.toLowerCase() ?? '') == 'gbp' ||
            (currency.code?.toLowerCase() ?? '') == 'eur')
        .toList();
  }
}
