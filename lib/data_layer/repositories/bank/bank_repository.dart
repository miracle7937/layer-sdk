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
  @override
  Future<List<Bank>> listByCountryCode({
    required String countryCode,
    bool forceRefresh = false,
  }) async {
    final bankDTOList = await _provider.listByCountryCode(
      countryCode: countryCode,
    );

    return bankDTOList.map((e) => e.toBank()).toList(growable: false);
  }
}
