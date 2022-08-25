import '../../models.dart';

/// Repository responsible for handling all the beneficiaries data.
abstract class ReceiptRepositoryInterface {
  /// Getting of the receipt.
  ///
  /// Returning list of bytes
  /// that represents receipt by provided format [type].
  Future<List<int>> getReceipt({
    required String objectId,
    required ReceiptActionType actionType,
    ReceiptType type = ReceiptType.image,
  });
}
