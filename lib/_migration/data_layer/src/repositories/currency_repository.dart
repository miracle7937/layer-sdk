import '../../models.dart';
import '../../providers.dart';
import '../mappings.dart';

/// Handles all the currency data
class CurrencyRepository {
  ///The [CurrencyProvider] object
  final CurrencyProvider provider;

  ///Creates a new repository with the supplied [CurrencyProvider]
  CurrencyRepository({
    required this.provider,
  });

  ///Lists the currencies
  Future<List<Currency>> list({
    bool forceRefresh = false,
  }) async {
    final dtos = await provider.list(
      forceRefresh: forceRefresh,
    );
    return dtos.map((e) => e.toCurrency()).toList(growable: false);
  }

  ///Gets a currency by a code
  Future<Currency?> getCurrencyByCode({
    required String code,
    bool forceRefresh = false,
  }) async {
    final dtos = await provider.getCurrencyByCode(
      code: code,
      forceRefresh: forceRefresh,
    );
    return dtos.isEmpty ? null : dtos[0].toCurrency();
  }
}
