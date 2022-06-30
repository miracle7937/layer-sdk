import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case to load all financial data
class LoadFinancialDataUseCase {
  final FinancialDataRepositoryInterface _repository;

  /// Creates a new [LoadFinancialDataUseCase] instance
  LoadFinancialDataUseCase({
    required FinancialDataRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to load all financial data of the supplied `customerId`
  Future<FinancialData> call({
    required String customerId,
    bool forceRefresh = false,
  }) =>
      _repository.loadFinancialData(
        customerId: customerId,
        forceRefresh: forceRefresh,
      );
}
