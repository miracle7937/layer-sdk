import '../../models.dart';

/// An abstract repository for the products
abstract class ProductRepositoryInterface {
  /// List the [Product]s
  ///
  /// Can be filtered by `searchQuery` and `productType`
  /// Use `limit` and `offset` to paginate.
  Future<List<Product>> list({
    String? productType,
    bool sortByName = false,
    bool forceRefresh = false,
    int limit = 50,
    int offset = 0,
    String? searchQuery,
  });

  /// Fetch [Product] by `productId`
  Future<Product> fetchProduct(String productId);
}
