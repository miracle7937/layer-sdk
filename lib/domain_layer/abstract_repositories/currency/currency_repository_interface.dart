import '../../models.dart';

/// The abstract repository for the currencies.
abstract class CurrencyRepositoryInterface {
  ///Lists the currencies
  Future<List<Currency>> list({
    bool forceRefresh = false,
    bool onlyVisible = true,
  });

  ///Gets a currency by a code
  Future<Currency?> getCurrencyByCode({
    required String code,
    bool forceRefresh = false,
  });
}
