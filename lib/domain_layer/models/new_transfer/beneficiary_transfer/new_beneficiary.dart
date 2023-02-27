import 'package:equatable/equatable.dart';

import '../../../models.dart';

/// Model that represents a new beneficiary that was created during
/// a beneficiary transfer flow.
class NewBeneficiary extends Equatable {
  /// Whether if the beneficiary should be saved or not.
  /// Default is `false`.
  final bool shouldSave;

  /// The nickname for this new beneficiary.
  final String? nickname;

  /// The country.
  final Country? country;

  /// The IBAN/Account number.
  final String? ibanOrAccountNO;

  /// Whether if the routing code is required or not.
  /// Default is `false`.
  final bool routingCodeIsRequired;

  /// The routing code.
  final String? routingCode;

  /// The bank.
  final Bank? bank;

  /// The transfer type to be used when transferring to this beneficiary.
  ///
  /// [bank.transferType] will be used by default if not provided.
  final TransferType? transferType;

  /// The first name.
  final String? firstName;

  /// The last name.
  final String? lastName;

  /// The currency.
  final Currency? currency;

  /// The first address field.
  final String? address1;

  /// The second address field.
  final String? address2;

  /// The third address field.
  final String? address3;

  /// The recipient type.
  final BeneficiaryRecipientType? type;

  /// Creates a new [NewBeneficiary].
  const NewBeneficiary({
    this.shouldSave = false,
    this.nickname,
    this.country,
    this.ibanOrAccountNO,
    this.routingCodeIsRequired = false,
    this.routingCode,
    this.bank,
    this.transferType,
    this.firstName,
    this.lastName,
    this.currency,
    this.address1,
    this.address2,
    this.address3,
    this.type,
  });

  /// Creates a copy with the passed parameters.
  NewBeneficiary copyWith({
    bool? shouldSave,
    String? nickname,
    Country? country,
    String? ibanOrAccountNO,
    bool? routingCodeIsRequired,
    String? routingCode,
    Bank? bank,
    TransferType? transferType,
    String? firstName,
    String? lastName,
    Currency? currency,
    String? address1,
    String? address2,
    String? address3,
    BeneficiaryRecipientType? type,
  }) =>
      NewBeneficiary(
        shouldSave: shouldSave ?? this.shouldSave,
        nickname:
            !(shouldSave ?? this.shouldSave) ? null : nickname ?? this.nickname,
        country: country ?? this.country,
        ibanOrAccountNO: ibanOrAccountNO ?? this.ibanOrAccountNO,
        routingCodeIsRequired:
            routingCodeIsRequired ?? this.routingCodeIsRequired,
        routingCode: routingCode ?? this.routingCode,
        bank: country != null && country != this.country
            ? null
            : bank ?? this.bank,
        transferType: transferType ?? this.transferType,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        currency: currency ?? this.currency,
        address1: address1 ?? this.address1,
        address2: address2 ?? this.address2,
        address3: address3 ?? this.address3,
        type: type ?? this.type,
      );

  /// Whether if the new beneficiary can be submitted or not.
  bool get canBeSubmitted =>
      (!shouldSave || (nickname?.isNotEmpty ?? false)) &&
      country != null &&
      ibanOrAccountNO != null &&
      (!routingCodeIsRequired || routingCode != null) &&
      (bank != null || transferType != null) &&
      firstName != null &&
      currency != null &&
      type != null;

  @override
  List<Object?> get props => [
        shouldSave,
        nickname,
        country,
        ibanOrAccountNO,
        routingCodeIsRequired,
        routingCode,
        bank,
        transferType,
        firstName,
        lastName,
        currency,
        address1,
        address2,
        address3,
        type,
      ];
}
