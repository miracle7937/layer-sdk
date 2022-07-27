import 'package:equatable/equatable.dart';

import '../../models.dart';

/// The status of a beneficiary
enum BeneficiaryStatus {
  /// Active
  active,

  /// Pending
  pending,

  /// Deleted
  deleted,

  /// Rejected
  rejected,

  /// OTP
  otp,

  /// System
  system,
}

/// The beneficiary data used by the application
class Beneficiary extends Equatable {
  /// The beneficiary id
  final int? id;

  /// The beneficiary's nickname
  final String nickname;

  /// The beneficiary's first name
  final String firstName;

  /// The beneficiary's last name
  final String lastName;

  /// The beneficiary's middle name
  final String middleName;

  /// The account number associated with this beneficiary.
  final String? accountNumber;

  /// The name of the bank where this beneficiary is a customer.
  final String bankName;

  /// The country code of the bank where this beneficiary is a customer.
  final String? bankCountryCode;

  /// The beneficiary's currency.
  final String? currency;

  /// The beneficiary's status.
  final BeneficiaryStatus? status;

  /// The beneficiary's type.
  final TransferType? type;

  /// Extra data for this beneficiary.
  final String? extra;

  /// The beneficiary's routing code.
  String? routingCode;

  /// Creates a new immutable [Beneficiary]
  Beneficiary({
    this.id,
    required this.nickname,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    this.accountNumber,
    required this.bankName,
    this.bankCountryCode,
    this.currency,
    this.status,
    this.type,
    this.extra,
    this.routingCode,
  });

  /// Returns the full name of this beneficiary
  String get fullName =>
      [firstName, middleName, lastName].where((e) => e.isNotEmpty).join(' ');

  @override
  List<Object?> get props => [
        id,
        nickname,
        firstName,
        lastName,
        middleName,
        accountNumber,
        bankName,
        bankCountryCode,
        currency,
        status,
        type,
        extra,
        routingCode,
      ];

  /// Returns beneficiary display name
  String get displayName =>
      [firstName, middleName, lastName].where((e) => e.isNotEmpty).join(' ');
}
