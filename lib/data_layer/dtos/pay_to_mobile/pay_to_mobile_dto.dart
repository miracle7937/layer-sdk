import '../../dtos.dart';
import '../../helpers/json_parser.dart';

/// Data transfer object representing a pay to mobile element.
class PayToMobileDTO {
  /// Unique send money request identifier.
  String? requestId;

  /// Unique customer identifier.
  String? customerId;

  /// Source account.
  AccountDTO? account;

  /// Destination customer identifier.
  String? toCustomer;

  /// Destination phone number.
  String? toMobile;

  /// The request type.
  PayToMobileRequestTypeDTO? requestTypeDTO;

  /// The amount.
  double? amount;

  /// The currency code.
  String? currencyCode;

  /// The pay to mobile status.
  PayToMobileStatusDTO? statusDTO;

  /// The withdrawal code generated by the service.
  String? withdrawalCode;

  /// The transaction code generated by the user.
  String? transactionCode;

  /// The second factor method used.
  SecondFactorTypeDTO? secondFactorTypeDTO;

  /// Expiry time of the request after which it will no longer be pending.
  DateTime? expiry;

  /// Created time of the request.
  DateTime? created;

  /// Updated time of the request.
  DateTime? updated;

  /// Creates a new [PayToMobileDTO].
  PayToMobileDTO({
    this.requestId,
    this.customerId,
    this.account,
    this.toCustomer,
    this.toMobile,
    this.requestTypeDTO,
    this.amount,
    this.currencyCode,
    this.statusDTO,
    this.withdrawalCode,
    this.transactionCode,
    this.secondFactorTypeDTO,
    this.expiry,
    this.created,
    this.updated,
  });

  /// Creates a [PayToMobileDTO] from a JSON.
  factory PayToMobileDTO.fromJson(Map<String, dynamic> json) => PayToMobileDTO(
        requestId: json['request_id'],
        customerId: json['customer_id'],
        account: json['from_account_details'] == null
            ? null
            : AccountDTO.fromJson(json['from_account_details']),
        toCustomer: json['to_customer'],
        toMobile: json['to_mobile'],
        requestTypeDTO: json['request_type'] == null
            ? null
            : PayToMobileRequestTypeDTO.fromString(
                json['request_type'],
              ),
        amount: JsonParser.parseDouble(json['amount']),
        currencyCode: json['currency'],
        statusDTO: json['status'] == null
            ? null
            : PayToMobileStatusDTO.fromString(json['status']),
        withdrawalCode: json['withdrawal_code'],
        transactionCode: json['withdrawal_pin'],
        secondFactorTypeDTO: SecondFactorTypeDTO.fromRaw(json['second_factor']),
        expiry: JsonParser.parseDate(json['ts_expiry']),
        created: JsonParser.parseDate(json['ts_created']),
        updated: JsonParser.parseDate(json['ts_updated']),
      );

  /// Returns a json map with the provided values.
  Map<String, dynamic> toJson() {
    return {
      if (requestId != null) 'request_id': requestId,
      if (customerId != null) 'customer_id': customerId,
      if (account != null) 'from_account_details': account?.toJson(),
      if (toCustomer != null) 'to_customer': toCustomer,
      if (toMobile != null) 'to_mobile': toMobile,
      if (requestTypeDTO != null) 'request_type': requestTypeDTO?.value,
      if (amount != null) 'amount': amount,
      if (currencyCode != null) 'currency': currencyCode,
      if (statusDTO != null) 'status': statusDTO?.value,
      if (withdrawalCode != null) 'withdrawal_code': withdrawalCode,
      if (transactionCode != null) 'withdrawal_pin': transactionCode,
      if (secondFactorTypeDTO != null)
        'second_factor': secondFactorTypeDTO?.value,
      if (expiry != null) 'ts_expiry': expiry?.millisecondsSinceEpoch,
      if (created != null) 'ts_created': created?.millisecondsSinceEpoch,
      if (updated != null) 'ts_updated': updated?.millisecondsSinceEpoch,
    };
  }
}