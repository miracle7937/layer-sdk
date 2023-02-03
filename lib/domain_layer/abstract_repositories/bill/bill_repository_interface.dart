import '../../models.dart';

/// Abstract definition for the [BillRepository].
abstract class BillRepositoryInterface {
  /// Validates the provided bill
  Future<Bill> validateBill({
    required Bill bill,
  });
}
