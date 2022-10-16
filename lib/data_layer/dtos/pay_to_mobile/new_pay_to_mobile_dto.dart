import '../../dtos.dart';

/// Data transfer object representing a new pay to mobile element.
class NewPayToMobileDTO {
  /// The source account identifier for this pay to mobile.
  String? accountId;

  /// The destination dial code.
  String? dialCode;

  /// The destination phone number.
  String? phoneNumber;

  /// The currency code.
  String? currencyCode;

  /// The amount of the transfer.
  double? amount;

  /// The transaction code created by the sender.
  String? transactionCode;

  /// The [PayToMobileRequestTypeDTO].
  PayToMobileRequestTypeDTO? requestTypeDTO;

  /// Creates a new [NewPayToMobileDTO].
  NewPayToMobileDTO({
    this.accountId,
    this.dialCode,
    this.phoneNumber,
    this.currencyCode,
    this.amount,
    this.transactionCode,
    this.requestTypeDTO,
  });

  /// Returns a json map with the provided values.
  Map<String, dynamic> toJson() {
    return {
      if (accountId != null) 'from_account': accountId,
      if (dialCode != null && phoneNumber != null)
        'to_mobile': '$dialCode$phoneNumber',
      if (currencyCode != null) 'currency': currencyCode,
      if (amount != null) 'amount': amount,
      if (transactionCode != null) 'withdrawal_pin': transactionCode,
      if (requestTypeDTO != null) 'request_type': requestTypeDTO!.value,
    };
  }
}
