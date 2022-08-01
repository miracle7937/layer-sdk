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

  /// Whether if the sort code is required or not.
  /// Default is `false`.
  final bool sortCodeIsRequired;

  /// The sort code.
  final String? sortCode;

  /// The bank.
  final Bank? bank;

  /// The first name.
  final String? firstName;

  /// The last name.
  final String? lastName;

  /// The currency.
  final Currency? currency;

  /// Creates a new [NewBeneficiary].
  const NewBeneficiary({
    this.shouldSave = false,
    this.nickname,
    this.country,
    this.ibanOrAccountNO,
    this.sortCodeIsRequired = false,
    this.sortCode,
    this.bank,
    this.firstName,
    this.lastName,
    this.currency,
  });

  /// Creates a copy with the passed parameters.
  NewBeneficiary copyWith({
    bool? shouldSave,
    String? nickname,
    Country? country,
    String? ibanOrAccountNO,
    bool? sortCodeIsRequired,
    String? sortCode,
    Bank? bank,
    String? firstName,
    String? lastName,
    Currency? currency,
  }) =>
      NewBeneficiary(
        shouldSave: shouldSave ?? this.shouldSave,
        nickname:
            !(shouldSave ?? this.shouldSave) ? null : nickname ?? this.nickname,
        country: country ?? this.country,
        ibanOrAccountNO: ibanOrAccountNO ?? this.ibanOrAccountNO,
        sortCodeIsRequired: sortCodeIsRequired ?? this.sortCodeIsRequired,
        sortCode: sortCode ?? this.sortCode,
        bank: country != null && country != this.country
            ? null
            : bank ?? this.bank,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        currency: currency ?? this.currency,
      );

  /// Whether if the new beneficiary can be submitted or not.
  bool get canBeSubmitted =>
      (!shouldSave || (nickname != null && (nickname?.isNotEmpty ?? false))) &&
      country != null &&
      ibanOrAccountNO != null &&
      (!sortCodeIsRequired || sortCode != null) &&
      bank != null &&
      firstName != null &&
      lastName != null &&
      currency != null;

  @override
  List<Object?> get props => [
        shouldSave,
        nickname,
        country,
        ibanOrAccountNO,
        sortCodeIsRequired,
        sortCode,
        bank,
        firstName,
        lastName,
        currency,
      ];
}
