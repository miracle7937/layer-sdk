import '../../models.dart';
import '../../providers.dart';
import '../mappings.dart';

/// Handles all the bills data
class BillRepository {
  final BillProvider _provider;

  /// Creates a new repository with the supplied [BillProvider]
  BillRepository(BillProvider provider) : _provider = provider;

  /// Lists all the bills of a customer in this
  /// limit/offset
  Future<List<Bill>> list({
    required String customerId,
    int limit = 50,
    int offset = 0,
    bool forceRefresh = false,
  }) async {
    final billDTOs = await _provider.list(
      customerId: customerId,
      offset: offset,
      limit: limit,
      forceRefresh: forceRefresh,
    );

    return billDTOs.map((e) => e.toBill()).toList(growable: false);
  }
}
