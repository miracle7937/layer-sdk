import 'package:collection/collection.dart';

import '../../helpers.dart';
import '../second_factor_dto.dart';
import 'service_dto.dart';
import 'service_field_dto.dart';

/// Data transfer object representing bills
/// retrieved from the payment service.
class BillDTO {
  /// The id of the bill.
  int? billId;

  /// The id of the customer.
  /// TODO: check with BE what this field represents
  String? customerId;

  /// The service linked to the bill
  ServiceDTO? service;

  /// The service id linked to the bill
  int? serviceId;

  /// The billing number of the bill
  String? billingNumber;

  /// The bill's nickname
  String? nickname;

  /// Whether the bill is recurring or not.
  bool? recurring;

  /// The bill's status
  BillDTOStatus? status;

  /// The amount of the bill
  dynamic amount;

  /// The minimum payable amount on the bill
  num? minPayment;

  /// The maximum payable amount on the bill
  num? maxPayment;

  /// The fees of the bill
  double? fees;

  /// The fees currency of the bill
  String? feesCurrency;

  /// The bill's due date
  DateTime? dueDate;

  /// The bill's issue date
  DateTime? issueDate;

  /// The bill's expiry date
  DateTime? expiryDate;

  /// The bill's validation code
  final String? validationCode;

  /// Date this bill was last created.
  final DateTime? created;

  /// Date this bill was last updated.
  final DateTime? updated;

  /// TODO: check with BE what this field means
  final String? comment;

  /// The billing fields for the bill
  List<ServiceFieldDTO>? billingFields;

  /// The additional fields for the bill
  /// TODO: check with BE what this field means
  Map<String, dynamic>? additionalFields;

  /// Whether a bill is visible to the customer
  bool? visible;

  /// The bill's billing amount
  double? billingAmount;

  /// The bill's second factor type
  SecondFactorDTO? secondFactor;

  /// The bill's image url
  String? imageUrl;

  /// Creates a new [BillDTO]
  BillDTO({
    this.billId,
    this.customerId,
    this.service,
    this.serviceId,
    this.billingNumber,
    this.nickname,
    this.recurring,
    this.status,
    this.amount,
    this.minPayment,
    this.maxPayment,
    this.fees,
    this.feesCurrency,
    this.dueDate,
    this.issueDate,
    this.expiryDate,
    this.validationCode,
    this.created,
    this.updated,
    this.comment,
    this.billingFields,
    this.additionalFields,
    this.visible,
    this.secondFactor,
    this.imageUrl,
  });

  /// Creates a new [BillDTO] from json
  factory BillDTO.fromJson(Map<String, dynamic> json) {
    return BillDTO(
      billId: json['bill_id'],
      customerId: json['customer_id'],
      serviceId: json['service_id'],
      service: ServiceDTO.fromJson(json['service']),
      billingNumber: json['billing_number'],
      nickname: json['nickname'],
      recurring: json['recurring'],
      status: BillDTOStatus.fromRaw(json['status']),
      amount: json['amount'] is String
          ? json['amount']
          : JsonParser.parseDouble(json['amount']),
      minPayment: json['min_pmt'],
      maxPayment: json['max_pmt'],
      comment: json['comment'],
      fees: JsonParser.parseDouble(json['fees']),
      feesCurrency: json['fees_currency'],
      dueDate: JsonParser.parseStringDate(json['due_date']),
      issueDate: JsonParser.parseStringDate(json['issue_date']),
      expiryDate: JsonParser.parseStringDate(json['expiry_date']),
      validationCode: json['validation_code'],
      created: JsonParser.parseDate(json['ts_created']),
      updated: JsonParser.parseDate(json['ts_updated']),
      billingFields: json['billing_fields'] != null
          ? ServiceFieldDTO.fromJsonList(json['billing_fields'])
          : [],
      additionalFields: json['additional_fields'],
      visible: json['visible'],
      secondFactor: SecondFactorDTO.fromRaw(json['second_factor']),
      imageUrl: json['image_url'],
    );
  }

  /// Creates a list of [BillDTO]s from the given JSON list.
  static List<BillDTO> fromJsonList(List json) =>
      json.map((bill) => BillDTO.fromJson(bill)).toList();
}

/// The bill status
class BillDTOStatus extends EnumDTO {
  /// bill is deleted
  static const deleted = BillDTOStatus._internal('D');

  /// bill is active
  static const active = BillDTOStatus._internal('A');

  /// bill is inactive
  static const inactive = BillDTOStatus._internal('I');

  /// bill is in pending otp validation
  static const otp = BillDTOStatus._internal('O');

  /// All the available bill status in a list
  static const List<BillDTOStatus> values = [deleted, inactive, active, otp];

  const BillDTOStatus._internal(String value) : super.internal(value);

  /// Creates a [BillDTOStatus] from a [String]
  static BillDTOStatus? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw,
      );
}
