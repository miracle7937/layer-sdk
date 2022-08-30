import '../../abstract_repositories.dart';
import '../../models/bill/bill.dart';

/// Use case for validating a bill
class ValidateBillUseCase {
  final BillRepositoryInterface _billRepository;

  /// Creates a new [ValidateBillUseCase] instance.
  ValidateBillUseCase({
    required BillRepositoryInterface billRepository,
  }) : _billRepository = billRepository;

  /// Validates the provided bill
  Future<Bill> call({
    required Bill bill,
  }) =>
      _billRepository.validateBill(
        bill: bill,
      );
}
