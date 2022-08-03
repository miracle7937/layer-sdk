import '../../models.dart';

/// Abstract definition for the [BillRepository].
abstract class BillRepositoryInterface {
  /// Lists all bills of the provided customer id.
  ///
  /// Use the `limit` and `offset` parameters to paginate.
  Future<List<Bill>> list({
    required String customerId,
    int limit = 50,
    int offset = 0,
    bool forceRefresh = false,
  });

  /// Validates the provided bill
  Future<Bill> validateBill({
    required Bill bill,
  });
}
