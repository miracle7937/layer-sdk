import '../../models.dart';

/// The abstract repository for the currencies.
abstract class CurrencyRepositoryInterface {
  ///Lists the currencies
  Future<List<Currency>> list({
    bool forceRefresh = false,
  });

  ///Gets a currency by a code
  Future<Currency?> getCurrencyByCode({
    required String code,
    bool forceRefresh = false,
  });

  ///Lists the available currencies
  Future<List<Currency>> getAvailable({
    bool forceRefresh = false,
  });
}
