import '../../../../features/pay_to_mobile_receiver.dart';
import '../../../models.dart';

/// Use case for posting a received mobile payment
class PostReceivedPaymentUseCase {
  /// Repository that handles serve calls
  final PayToMobileReceiverRepositoryInterface _repository;

  /// Creates a new [PostReceivedPaymentUseCase]
  PostReceivedPaymentUseCase({
    required PayToMobileReceiverRepositoryInterface repository,
  }) : _repository = repository;

  /// Post the mobile payment
  Future<void> call({
    required String fromSendMoneyId,
    required String accountId,
    required String withdrawalCode,
    required String withdrawalPin,
    required String deviceUUID,
    String? reason,
    Beneficiary? beneficiary,
  }) async {
    return await _repository.postReceivedTransfer(
      fromSendMoneyId: fromSendMoneyId,
      accountId: accountId,
      withdrawalCode: withdrawalCode,
      withdrawalPin: withdrawalPin,
      deviceUUID: deviceUUID,
    );
  }
}
