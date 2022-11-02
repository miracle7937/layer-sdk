import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Handles the banks data.
class BankRepository implements BankRepositoryInterface {
  final BankProvider _provider;

  /// Creates a new [BankRepository].
  const BankRepository({
    required BankProvider provider,
  }) : _provider = provider;

  /// Lists the banks for the provided country code.
  ///
  /// Use the [limit] and [offset] parameters for pagination purposes.
  /// The [query] parameter can bu used for filtering the results.
  @override
  Future<List<Bank>> listByCountryCode({
    required String countryCode,
    int? limit,
    int? offset,
    String? query,
    bool forceRefresh = false,
  }) async {
    final bankDTOList = await _provider.listByCountryCode(
      countryCode: countryCode,
      limit: limit,
      offset: offset,
      query: query,
      forceRefresh: forceRefresh,
    );

    return bankDTOList.map((e) => e.toBank()).toList(growable: false);
  }

  /// Returns the bank with the corresponding
  /// swift code
  @override
  Future<Bank> getBankByBIC({
    required String bic,
    bool forceRefresh = false,
  }) async {
    final bank = await _provider.getBankByBIC(
      bic: bic,
      forceRefresh: forceRefresh,
    );

    return bank.toBank();
  }
}
