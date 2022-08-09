import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Handles all the currency data
class CurrencyRepository implements CurrencyRepositoryInterface {
  ///The [CurrencyProvider] object
  final CurrencyProvider provider;

  ///Creates a new repository with the supplied [CurrencyProvider]
  CurrencyRepository({
    required this.provider,
  });

  ///Lists the currencies
  @override
  Future<List<Currency>> list({
    bool forceRefresh = false,
    bool onlyVisible = true,
  }) async {
    final dtos = await provider.list(
      forceRefresh: forceRefresh,
      onlyVisible: onlyVisible,
    );
    return dtos.map((e) => e.toCurrency()).toList(growable: false);
  }

  ///Gets a currency by a code
  @override
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
