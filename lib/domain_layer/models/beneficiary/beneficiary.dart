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

  /// The sort code associated with this beneficiary's account.
  final String? sortCode;

  /// The IBAN associated with this beneficiary.
  final String? iban;

  /// The bank where this beneficiary is a customer.
  final Bank? bank;

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

  /// The address, line 1.
  final String? address1;

  /// The address, line 2.
  final String? address2;

  /// The address, line 3.
  final String? address3;

  /// The OTP id
  final int? otpId;

  /// Extra data for this beneficiary.
  final String? extra;

  /// Creates a new immutable [Beneficiary]
  Beneficiary({
    this.id,
    required this.nickname,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    this.accountNumber,
    this.sortCode,
    this.iban,
    this.bank,
    required this.bankName,
    this.bankCountryCode,
    this.currency,
    this.status,
    this.type,
    this.address1,
    this.address2,
    this.address3,
    this.otpId,
    this.extra,
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
        sortCode,
        iban,
        bank,
        bankName,
        bankCountryCode,
        currency,
        status,
        type,
        address1,
        address2,
        address3,
        otpId,
        extra,
      ];

  /// Returns beneficiary display name
  String get displayName =>
      [firstName, middleName, lastName].where((e) => e.isNotEmpty).join(' ');

  /// Creates a new beneficiary based on this one.
  Beneficiary copyWith({
    int? id,
    String? nickname,
    String? firstName,
    String? lastName,
    String? middleName,
    String? accountNumber,
    String? sortCode,
    String? iban,
    Bank? bank,
    String? bankName,
    String? bankCountryCode,
    String? currency,
    BeneficiaryStatus? status,
    TransferType? type,
    String? address1,
    String? address2,
    String? address3,
    int? otpId,
  }) =>
      Beneficiary(
        id: id ?? this.id,
        nickname: nickname ?? this.nickname,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        middleName: middleName ?? this.middleName,
        accountNumber: accountNumber ?? this.accountNumber,
        sortCode: sortCode ?? this.sortCode,
        iban: iban ?? this.iban,
        bank: bank ?? this.bank,
        bankName: bankName ?? this.bankName,
        bankCountryCode: bankCountryCode ?? this.bankCountryCode,
        currency: currency ?? this.currency,
        status: status ?? this.status,
        type: type ?? this.type,
        address1: address1 ?? this.address1,
        address2: address2 ?? this.address2,
        address3: address3 ?? this.address3,
        otpId: otpId ?? this.otpId,
      );
}
