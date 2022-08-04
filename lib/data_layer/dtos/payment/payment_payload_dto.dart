import '../../dtos.dart';

/// The payment payload DTO
class PaymenShortcuttPayloadDTO {
  /// The bill amount
  double? amount;

  /// The payment ID
  int? paymentId;

  /// The bill object
  BillDTO? bill;

  /// The device uid
  String? deviceUID;

  /// The otp ID
  int? otpId;

  /// The payment status
  PaymentDTOStatus? status;

  /// The currency used
  String? currency;

  /// The from account id
  String? fromAccountId;

  /// The from account
  AccountDTO? fromAccount;

  /// The wallet id
  int? fromWalletId;

  /// Creates a new [PaymenShortcuttPayloadDTO]
  PaymenShortcuttPayloadDTO({
    this.paymentId,
    this.bill,
    this.amount,
    this.currency,
    this.otpId,
    this.status,
    this.deviceUID,
    this.fromAccount,
    this.fromAccountId,
    this.fromWalletId,
  });

  /// To json function used for shortcuts
  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{
      'amount': amount,
      'payment_id': paymentId,
      'bill': bill!.toJson(
        includeNickname: false,
        visible: false,
        includeBillId: false,
      ),
      'device_uid': deviceUID,
      'otp_id': otpId,
      'status': status?.value,
      'currency': currency,
      'from_account_id': fromAccountId,
      'from_account': fromAccount!.toJson(),
      'from_wallet_id': fromWalletId,
    };

    return json;
  }
}
