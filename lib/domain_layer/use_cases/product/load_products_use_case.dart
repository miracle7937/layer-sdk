import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case responsible for load products
class LoadProductsUseCase {
  final ProductRepositoryInterface _repository;

  /// Creates a new [LoadProductsUseCase] instance
  LoadProductsUseCase({
    required ProductRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to load all products
  ///
  /// Can be filtered by `searchQuery` and `productType`
  ///
  /// Use `limit` and `offset` to paginate.
  Future<List<Product>> call({
    String? productType,
    bool sortByName = false,
    bool forceRefresh = false,
    int limit = 50,
    int offset = 0,
    String? searchQuery,
  }) {
    return _repository.list(
      productType: productType,
      sortByName: sortByName,
      forceRefresh: forceRefresh,
      limit: limit,
      offset: offset,
      searchQuery: searchQuery,
    );
  }
}
