import '../../../models.dart';

/// An abstract repository for PayToMobileReceiver
abstract class PayToMobileReceiverRepositoryInterface {
  /// Posts a received mobile payment
  Future<void> postReceivedTransfer({
    required String fromSendMoneyId,
    required String accountId,
    required String withdrawalCode,
    required String withdrawalPin,
    required String deviceUUID,
    String? reason,
    Beneficiary? beneficiary,
  });
}
