import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../mappings.dart';
import '../../network.dart';

/// Provides data about billers
class BillerProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  /// Creates a new [BillerProvider] with the supplied [NetClient].
  BillerProvider({
    required this.netClient,
  });

  /// Returns the billers.
  ///
  /// * Use `status` to filter billers by their status
  /// * Use `categoryId` to filter billers by their category
  Future<List<BillerDTO>> list({
    BillerStatus status = BillerStatus.active,
    String? categoryId,
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.biller,
      method: NetRequestMethods.get,
      queryParameters: {
        'status': status.toDTOStatus(),
        if (categoryId?.isNotEmpty ?? false) 'category_id': categoryId,
      },
      forceRefresh: forceRefresh,
    );

    return BillerDTO.fromJsonList(
      List.from(response.data),
    );
  }
}
