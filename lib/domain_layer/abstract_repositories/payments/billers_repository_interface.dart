import '../../models/payment/biller.dart';

/// Abstract definition of the repository that handles all the biller data.
abstract class BillersRepositoryInterface {
  /// Lists all the billers
  ///
  /// * Use `status` to filter billers by their status
  /// * Use `categoryId` to filter billers by their category
  Future<List<Biller>> listBillers({
    BillerStatus status = BillerStatus.active,
    String? categoryId,
  });
}
