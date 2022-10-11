import '../../domain_layer/models/transactions_filters.dart';
import '../dtos/transactions_filters_dto.dart';

/// Extension that provides mapping for [TransactionFiltersDTO]
extension TransactionFiltersDTOMapping on TransactionFiltersDTO {
  /// Maps a [TransactionFiltersDTO] instance to
  ///  a [TransactionFilters] model
  TransactionFilters toTransactionFilters() => TransactionFilters(
        minAmount: minAmount,
        maxAmount: maxAmount,
        currencies: currencies,
      );
}
