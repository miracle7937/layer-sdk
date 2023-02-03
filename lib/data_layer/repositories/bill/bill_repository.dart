import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Handles all the bills data
class BillRepository implements BillRepositoryInterface {
  final BillProvider _provider;

  /// Creates a new repository with the supplied [BillProvider]
  BillRepository(BillProvider provider) : _provider = provider;

  @override
  Future<Bill> validateBill({required Bill bill}) async {
    final billDTO = await _provider.validateBill(
      bill: bill.toBillDTO(),
    );

    return billDTO.toBill();
  }
}
