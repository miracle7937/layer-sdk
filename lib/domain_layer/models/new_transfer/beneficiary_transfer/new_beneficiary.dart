import 'package:equatable/equatable.dart';

import '../../../models.dart';

/// Model that represents a new beneficiary that was created during
/// a beneficiary transfer flow.
class NewBeneficiary extends Equatable {
  /// The country.
  final Country? country;

  /// The IBAN/Account number.
  final String? ibanOrAccountNO;

  /// The sort code.
  final String? sortCode;

  /// The bank name.
  final String? bankName;

  /// The first name.
  final String? firstName;

  /// The last name.
  final String? lastName;

  /// The currency.
  final Currency? currency;

  /// Creates a new [NewBeneficiary].
  const NewBeneficiary({
    this.country,
    this.ibanOrAccountNO,
    this.sortCode,
    this.bankName,
    this.firstName,
    this.lastName,
    this.currency,
  });

  /// Creates a copy with the passed parameters.
  NewBeneficiary copyWith({
    /// The country.
    Country? country,
    String? ibanOrAccountNO,
    String? sortCode,
    String? bankName,
    String? firstName,
    String? lastName,
    Currency? currency,
  }) =>
      NewBeneficiary(
        country: country ?? this.country,
        ibanOrAccountNO: ibanOrAccountNO ?? this.ibanOrAccountNO,
        sortCode: sortCode ?? this.sortCode,
        bankName: bankName ?? this.bankName,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        currency: currency ?? this.currency,
      );

  /// Whether if the new beneficiary can be submitted or not.
  bool get canBeSubmitted =>
      country != null &&
      ibanOrAccountNO != null &&
      sortCode != null &&
      bankName != null &&
      firstName != null &&
      lastName != null &&
      currency != null;

  @override
  List<Object?> get props => [
        country,
        ibanOrAccountNO,
        sortCode,
        bankName,
        firstName,
        lastName,
        currency,
      ];
}
