import 'package:equatable/equatable.dart';

import '../../models.dart';

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
  final BillStatus? billStatus;

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

  /// Creates a new [Bill]
  Bill({
    this.billID,
    this.nickname,
    this.service,
    this.billStatus,
    this.billingNumber,
    this.billerName,
    this.utility,
    this.created,
    this.amount,
    this.hideValues = false,
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
      );
}
