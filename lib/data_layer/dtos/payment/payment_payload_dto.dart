import '../../dtos.dart';

/// The payment payload DTO
class PaymentPayloadDTO {
  ///
  double? amount;

  ///
  int? paymentId;

  ///
  BillDTO? bill;

  ///
  String? deviceUID;

  ///
  int? otpId;

  ///
  PaymentDTOStatus? status;

  ///
  String? currency;

  ///
  String? fromAccountId;

  ///
  AccountDTO? fromAccount;

  ///
  int? fromWalletId;

  /// Creates a new [PaymentPayloadDTO]
  PaymentPayloadDTO({
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
      'bill': bill!.toJson(),
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
