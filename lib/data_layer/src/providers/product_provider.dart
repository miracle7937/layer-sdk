import '../../network.dart';
import '../dtos.dart';
import '../helpers/dto_helpers.dart';

/// Provider that handles API requests for [ProductDTO]
class ProductProvider {
  /// Network manager
  final NetClient netClient;

  /// Creates a new instance of [ProductProvider]
  const ProductProvider({
    required this.netClient,
  });

  /// List all avalilable banking products
  Future<List<ProductDTO>> list({
    String? productType,
    bool sortByName = false,
    bool forceRefresh = false,
    int limit = 50,
    int offset = 0,
    String? searchQuery,
  }) async {
    final params = <String, dynamic>{
      'limit': limit,
      'offset': offset,
    };

    if (isNotEmpty(searchQuery)) {
      params['q'] = searchQuery;
    }

    if (isNotEmpty(productType)) {
      params['product_type'] = productType;
    }
    if (sortByName) {
      params['sortby'] = "name";
    }
    final response = await netClient.request(
      netClient.netEndpoints.products,
      method: NetRequestMethods.get,
      queryParameters: params,
    );

    return ProductDTO.fromJsonList(response.data);
  }

  /// Fetch [ProductDTO] by id
  Future<ProductDTO> fetchProduct(String productId) async {
    final response = await netClient.request(
      '${netClient.netEndpoints.products}/$productId',
      method: NetRequestMethods.get,
    );

    return ProductDTO.fromJson(response.data);
  }
}
