import '../../../domain_layer/models.dart';
import '../../network/endpoints/net_endpoints.dart';

/// Extension that provides mappings for [ReceiptActionType].
extension ReceiptActionTypeMapping on ReceiptActionType {
  /// Maps into a backend query data.
  String toQueryData() {
    switch (this) {
      case ReceiptActionType.beneficiary:
        return 'beneficiary';

      case ReceiptActionType.transfer:
        return 'transfer_c2c';

      case ReceiptActionType.payment:
        return 'bill_payment';

      case ReceiptActionType.topUp:
        return 'payment_intent_receipt';

      case ReceiptActionType.payToMobile:
        throw Exception('Unhandled toQueryData for $this');
    }
  }

  /// Maps into a backend query string.
  String toQueryString(NetEndpoints netEndpoints) {
    switch (this) {
      case ReceiptActionType.beneficiary:
        return netEndpoints.beneficiaryReceipt;

      case ReceiptActionType.transfer:
        return netEndpoints.transferReceipt;

      case ReceiptActionType.payment:
        return netEndpoints.paymentReceipt;

      case ReceiptActionType.topUp:
        return netEndpoints.topUpReceipt;

      case ReceiptActionType.payToMobile:
        throw Exception('Unhandled toQueryString for $this');
    }
  }
}
