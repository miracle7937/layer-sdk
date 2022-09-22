import 'package:collection/collection.dart';

import '../../dtos.dart';
import '../../helpers.dart';

/// Data transfer object representing payments
/// in the payment service.
class PaymentDTO {
  /// The id of the payment
  int? paymentId;

  /// TODO: ask BE
  DateTime? paymentTs;

  /// The bill of the payment
  BillDTO? bill;

  /// The id of the bill of the payment
  int? billId;

  /// The from card id of the payment
  int? fromCardId;

  /// The from card of the payment
  CardDTO? fromCard;

  /// The from account of the payment
  AccountDTO? fromAccount;

  /// The from account id of the payment
  String? fromAccountId;

  /// The from wallet id of the payment
  int? fromWalletId;

  /// The payment status
  PaymentDTOStatus? status;

  /// The payment otp id
  int? otpId;

  /// A unique identifier of the payment
  String? deviceUID;

  /// The second factor type of the payment
  SecondFactorTypeDTO? secondFactor;

  /// The date of creation of the payment
  DateTime? created;

  /// The date the payment was last updated
  DateTime? updated;

  /// The date the payment is scheduled to happen on
  DateTime? scheduled;

  /// The amount of the payment
  double? amount;

  /// Whether the `amount` should be shown
  bool amountVisible;

  /// The currency of the payment
  String? currency;

  /// The type of recurrence of the payment
  RecurrenceDTO? recurrence;

  /// The recurrence start date of the payment
  DateTime? recurrenceStart;

  /// The recurrence end date of the payment
  DateTime? recurrenceEnd;

  /// Whether the payment is recurring or not
  bool? recurring;

  /// Creates a new [PaymentDTO]
  PaymentDTO({
    this.paymentId,
    this.paymentTs,
    this.bill,
    this.billId,
    this.fromCardId,
    this.fromCard,
    this.fromAccount,
    this.fromAccountId,
    this.amount,
    this.amountVisible = true,
    this.recurrence,
    this.currency,
    this.status,
    this.otpId,
    this.deviceUID,
    this.secondFactor,
    this.created,
    this.updated,
    this.fromWalletId,
    this.scheduled,
    this.recurrenceStart,
    this.recurrenceEnd,
    this.recurring,
  });

  /// Creates a [PaymentDTO] from a JSON
  factory PaymentDTO.fromJson(
    Map<String, dynamic> json, {
    bool ignoreRecurrence = false,
  }) {
    return PaymentDTO(
      paymentId: json['payment_id'],
      paymentTs: JsonParser.parseDate(json['payment_ts']),
      billId: json['bill_id'],
      bill: BillDTO.fromJson(json['bill']),
      fromAccount: json['from_account_id'] != null
          ? AccountDTO.fromJson(json['from_account'])
          : null,
      fromAccountId: json['from_account_id'],
      fromCard: json['from_card_id'] != null
          ? CardDTO.fromJson(json['from_card'])
          : null,
      fromCardId: json['from_card_id'],
      fromWalletId: json['from_wallet_id'],
      amount:
          json['amount'] is num ? JsonParser.parseDouble(json['amount']) : 0.0,
      amountVisible: !(json['amount'] is String &&
          json['amount'].toLowerCase().contains('x')),
      currency: json['currency'],
      otpId: json['otp_id'],
      deviceUID: json['device_uid'],
      status: PaymentDTOStatus.fromRaw(json['status']),
      secondFactor: SecondFactorTypeDTO.fromRaw(json['second_factor']),
      created: JsonParser.parseDate(json['ts_created']),
      scheduled: JsonParser.parseDate(json['ts_scheduled']),
      recurrence:
          ignoreRecurrence ? null : RecurrenceDTO.fromRaw(json["recurrence"]),
      recurrenceStart: JsonParser.parseDate(json["recurrence_start"]),
      recurrenceEnd: JsonParser.parseDate(json["recurrence_end"]),
      recurring: json['recurring'],
    );
  }

  /// Creates a JSON map from the model data
  Map<String, dynamic> toJson() {
    return {
      'payment_id': paymentId,
      'payment_ts': paymentTs?.millisecondsSinceEpoch,
      'bill_id': billId,
      'bill': bill?.toJson(),
      'from_account_id': fromAccountId,
      'from_card_id': fromCardId,
      'amount': amount,
      'currency': currency,
      'otp_id': otpId,
      'device_uid': deviceUID,
      'status': status?.value,
      'second_factor': secondFactor?.value,
      'ts_created': created?.millisecondsSinceEpoch,
      'ts_scheduled': scheduled?.millisecondsSinceEpoch,
      'recurrence': recurrence?.value,
      'recurrence_start': recurrenceStart?.millisecondsSinceEpoch,
      'recurrence_end': recurrenceEnd?.millisecondsSinceEpoch,
      if (recurring != null) 'recurring': recurring,
    };
  }

  /// Creates a list of [PaymentDTO]s from the given JSON list.
  static List<PaymentDTO> fromJsonList(
    List<Map<String, dynamic>> json, {
    bool ignoreRecurrence = false,
  }) =>
      json
          .map((e) => PaymentDTO.fromJson(
                e,
                ignoreRecurrence: ignoreRecurrence,
              ))
          .toList();
}

/// payment status options
class PaymentDTOStatus extends EnumDTO {
  /// payment status is pending OTP
  static const otp = PaymentDTOStatus._internal('O');

  /// payment status has expired OTP
  static const otpExpired = PaymentDTOStatus._internal('T');

  /// payment status is failed
  static const failed = PaymentDTOStatus._internal('F');

  /// payment status is completed
  static const completed = PaymentDTOStatus._internal('C');

  /// payment status is deleted
  static const deleted = PaymentDTOStatus._internal('D');

  /// payment status is pending approval
  static const pending = PaymentDTOStatus._internal('P');

  /// payment status is cancelled
  static const cancelled = PaymentDTOStatus._internal('X');

  /// payment status is scheduled
  static const scheduled = PaymentDTOStatus._internal('S');

  /// payment status is pending bank approval
  static const pendingBank = PaymentDTOStatus._internal('B');

  /// payment status is pending expired
  static const pendingExpired = PaymentDTOStatus._internal('E');

  /// All the available payment status values in a list
  static const List<PaymentDTOStatus> values = [
    otp,
    otpExpired,
    failed,
    completed,
    pending,
    cancelled,
    scheduled,
    pendingBank,
    pendingExpired,
    deleted,
  ];

  const PaymentDTOStatus._internal(String value) : super.internal(value);

  /// Creates a [PaymentDTOStatus] from a [String]
  static PaymentDTOStatus? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw?.toUpperCase(),
      );
}
