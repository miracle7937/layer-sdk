import '../../../migration/data_layer/network.dart';
import '../dtos.dart';

/// A provider that handles API requests related to [CategoryDTO].
class CategoryProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  ///Creates a new [CategoryProvider]
  const CategoryProvider({
    required this.netClient,
  });

  ///Lists the categories
  Future<List<CategoryDTO>> list({
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.category,
      method: NetRequestMethods.get,
      forceRefresh: forceRefresh,
    );

    return CategoryDTO.fromJsonList(response.data);
  }
}
