import '../../models.dart';
import '../mappings.dart';
import '../providers/product_provider.dart';

/// Repository that handle Product data
class ProductRepository {
  /// Provider
  final ProductProvider provider;

  /// Creates a new instance of [ProductRepository]
  ProductRepository({
    required this.provider,
  });

  /// List the [Product]s
  Future<List<Product>> list({
    String? productType,
    bool sortByName = false,
    bool forceRefresh = false,
    int limit = 50,
    int offset = 0,
    String? searchQuery,
  }) async {
    final products = await provider.list(
      productType: productType,
      sortByName: sortByName,
      forceRefresh: forceRefresh,
      limit: limit,
      offset: offset,
      searchQuery: searchQuery,
    );

    return products.map((p) => p.toProduct()).toList();
  }

  /// Fetch a [Product] by id
  Future<Product> fetchProduct(String productId) async {
    final product = await provider.fetchProduct(productId);
    return product.toProduct();
  }
}
