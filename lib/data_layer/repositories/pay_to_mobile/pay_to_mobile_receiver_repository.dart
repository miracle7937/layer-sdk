import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// PayToMobile receiver repository
class PayToMobileReceiverRepository
    extends PayToMobileReceiverRepositoryInterface {
  /// Provider that handles server calls
  final PayToMobileReceiverProvider _provider;

  /// Creates a new [PayToMobileReceiverRepository]
  PayToMobileReceiverRepository({
    required PayToMobileReceiverProvider provider,
  }) : _provider = provider;

  @override
  Future<void> postReceivedTransfer({
    required String fromSendMoneyId,
    required String accountId,
    required String withdrawalCode,
    required String withdrawalPin,
    required String deviceUUID,
    String? reason,
    Beneficiary? beneficiary,
  }) async {
    return await _provider.postReceivedTransfer(
      fromSendMoneyId: fromSendMoneyId,
      accountId: accountId,
      withdrawalCode: withdrawalCode,
      withdrawalPin: withdrawalPin,
      beneficiary: beneficiary?.toBeneficiaryDTO(),
      deviceUUID: deviceUUID,
    );
  }
}
