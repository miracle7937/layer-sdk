import '../../../domain_layer/abstract_repositories/payments/billers_repository_interface.dart';
import '../../../domain_layer/models/payment/biller.dart';
import '../../mappings/payment/biller_dto_mapping.dart';
import '../../providers/payments/biller_provider.dart';

/// Handles all the biller data
class BillersRepository extends BillersRepositoryInterface {
  final BillerProvider _provider;

  /// Creates a new repository with the supplied [BillerProvider]
  BillersRepository(
    BillerProvider provider,
  ) : _provider = provider;

  @override
  Future<List<Biller>> listBillers({
    String? status,
    String? categoryId,
  }) async {
    final billers = await _provider.list(
      status: status,
      categoryId: categoryId,
    );

    return billers.map((e) => e.toBiller()).toList(growable: false);
  }
}
