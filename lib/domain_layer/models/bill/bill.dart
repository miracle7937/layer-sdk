import 'package:equatable/equatable.dart';

import '../../models.dart';
import '../service/service_field.dart';

/// The status a bill can have
enum BillStatus {
  /// Active
  active,

  /// Inactive
  inactive,

  /// OTP
  otp,

  /// Deleted
  deleted,

  /// Unknown
  unknown,
}

/// Keeps the data of a bill
class Bill extends Equatable {
  /// The id of the bill
  final int? billID;

  /// The nickname of the bill
  final String? nickname;

  /// The bill's service
  final Service? service;

  /// This bill status
  final BillStatus billStatus;

  /// The billing number of the bill
  final String? billingNumber;

  /// The biller name
  final String? billerName;

  /// The utility of the bill
  final String? utility;

  /// Date when the bill was created
  final DateTime? created;

  /// Amount of this bill
  final double? amount;

  /// Whether or not the value of this [Bill] should be hidden.
  final bool hideValues;

  /// The billing fields for the bill
  final List<ServiceField> billingFields;

  /// Whether a bill is visible to the customer
  final bool visible;

  /// The fees of the bill
  final double fees;

  /// The id of the customer.
  final String? customerId;

  /// Whether the bill is recurring or not.
  final bool recurring;

  /// The currency of the bill's fees
  final String? feesCurrency;

  /// The bill's second factor type
  final SecondFactorType? secondFactor;

  /// Creates a new [Bill]
  Bill({
    this.billID,
    this.nickname,
    this.service,
    this.billStatus = BillStatus.unknown,
    this.billingNumber,
    this.billerName,
    this.utility,
    this.created,
    this.amount,
    this.hideValues = false,
    this.billingFields = const [],
    this.visible = false,
    this.fees = 0,
    this.customerId,
    this.recurring = false,
    this.feesCurrency,
    this.secondFactor,
  });

  @override
  List<Object?> get props => [
        billID,
        nickname,
        service,
        billStatus,
        billingNumber,
        billerName,
        utility,
        created,
        amount,
        hideValues,
        billingFields,
        visible,
        fees,
        customerId,
        recurring,
        feesCurrency,
        secondFactor,
      ];

  /// Creates a copy of this bill with different values
  Bill copyWith({
    int? billID,
    String? nickname,
    Service? service,
    BillStatus? billStatus,
    String? billingNumber,
    String? billerName,
    String? utility,
    DateTime? created,
    bool? hideValues,
    double? amount,
    List<ServiceField>? billingFields,
    bool? visible,
    double? fees,
    String? customerId,
    bool? recurring,
    String? feesCurrency,
    SecondFactorType? secondFactor,
  }) =>
      Bill(
        billID: billID ?? this.billID,
        nickname: nickname ?? this.nickname,
        service: service ?? this.service,
        billStatus: billStatus ?? this.billStatus,
        billingNumber: billingNumber ?? this.billingNumber,
        billerName: billerName ?? this.billerName,
        utility: utility ?? this.utility,
        created: created ?? this.created,
        hideValues: hideValues ?? this.hideValues,
        amount: amount ?? amount,
        billingFields: billingFields ?? this.billingFields,
        visible: visible ?? this.visible,
        fees: fees ?? this.fees,
        customerId: customerId ?? this.customerId,
        recurring: recurring ?? this.recurring,
        feesCurrency: feesCurrency ?? feesCurrency,
        secondFactor: secondFactor ?? secondFactor,
      );
}
