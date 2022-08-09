import '../../abstract_repositories/payments/billers_repository_interface.dart';
import '../../models/payment/biller.dart';

/// Use case to load billers data
class LoadBillersUseCase {
  final BillersRepositoryInterface _repository;

  /// Creates a new [LoadBillersUseCase] instance
  LoadBillersUseCase(
    BillersRepositoryInterface repository,
  ) : _repository = repository;

  /// Callable method to load billers data
  Future<List<Biller>> call({
    String? status = 'A',
    String? categoryId,
  }) {
    return _repository.listBillers(
      status: status,
      categoryId: categoryId,
    );
  }
}
