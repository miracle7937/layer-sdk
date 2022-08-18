import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../providers.dart';

/// Handles receipts data
class ReceiptRepository implements ReceiptRepositoryInterface {
  final ReceiptProvider _provider;

  /// Creates a new repository with the supplied [ReceiptProvider]
  ReceiptRepository({
    required ReceiptProvider provider,
  }) : _provider = provider;

  /// Getting of the receipt.
  ///
  /// Returning list of bytes
  /// that represents receipt by provided format [type].
  @override
  Future<List<int>> getReceipt({
    required String objectId,
    required ReceiptActionType actionType,
    ReceiptType type = ReceiptType.image,
  }) async {
    final bytes = await _provider.getReceipt(
      objectId: objectId,
      actionType: actionType,
      type: type,
    );

    return bytes;
  }
}
