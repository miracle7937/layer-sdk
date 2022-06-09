import 'package:collection/collection.dart';

import '../../helpers.dart';

/// Data transfer object representing an account loan payment.
class AccountLoanPaymentDTO {
  /// The payment id.
  String? id;

  /// The loan id;
  int? loanId;

  /// The date when the payment was created;
  DateTime? created;

  /// The date when the payment was last updated.
  DateTime? updated;

  /// The payment amount.
  double? amount;

  /// The payment currency.
  String? currency;

  /// The date that the payment was issued.
  DateTime? issuance;

  /// The date the payment is due.
  DateTime? maturity;

  /// The number used to identify the payment by the customer.
  int? paymentSerial;

  /// The amount of the payment fees.
  double? fees;

  /// The currency of the payment fees.
  String? feesCurrency;

  /// The payment status.
  AccountLoanPaymentStatusDTO? status;

  /// Creates [AccountLoanPaymentDTO].
  AccountLoanPaymentDTO({
    this.id,
    this.loanId,
    this.created,
    this.updated,
    this.amount,
    this.currency,
    this.issuance,
    this.maturity,
    this.paymentSerial,
    this.fees,
    this.feesCurrency,
    this.status,
  });

  /// Creates [AccountLoanPaymentDTO] from a json map.
  factory AccountLoanPaymentDTO.fromJson(Map<String, dynamic> json) {
    return AccountLoanPaymentDTO(
      id: json['payment_id'],
      loanId: JsonParser.parseInt(json['account_loan_id']),
      created: JsonParser.parseDate(json['ts_created']),
      updated: JsonParser.parseDate(json['ts_updated']),
      amount: JsonParser.parseDouble(json['amount']),
      currency: json['currency'],
      issuance: JsonParser.parseStringDate(json['issuance_date']),
      maturity: JsonParser.parseStringDate(json['maturity_date']),
      paymentSerial: JsonParser.parseInt(json['payment_serial']),
      fees: JsonParser.parseDouble(json['fees']),
      feesCurrency: json['fees_currency'],
      status: AccountLoanPaymentStatusDTO.fromRaw(json['status']),
    );
  }

  /// Creates a [AccountLoanPaymentDTO]s from a list of json maps.
  static List<AccountLoanPaymentDTO> fromJsonList(
          List<Map<String, dynamic>> json) =>
      json.map(AccountLoanPaymentDTO.fromJson).toList();
}

/// The account loan payment statuses.
class AccountLoanPaymentStatusDTO extends EnumDTO {
  /// The payment was paid.
  static const AccountLoanPaymentStatusDTO paid =
      AccountLoanPaymentStatusDTO._internal('P');

  /// The payment was not paid.
  static const AccountLoanPaymentStatusDTO unpaid =
      AccountLoanPaymentStatusDTO._internal('U');

  /// All possible values for the payment status.
  static const values = [
    paid,
    unpaid,
  ];

  const AccountLoanPaymentStatusDTO._internal(String value)
      : super.internal(value);

  /// Creates [AccountLoanPaymentStatusDTO] from raw value.
  static AccountLoanPaymentStatusDTO? fromRaw(String? raw) =>
      values.firstWhereOrNull(
        (element) => element.value == raw,
      );
}
