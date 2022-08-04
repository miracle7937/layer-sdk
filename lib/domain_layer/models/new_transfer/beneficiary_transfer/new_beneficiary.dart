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
    this.routingCodeIsRequired = false,
    this.routingCode,
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
    bool? routingCodeIsRequired,
    String? routingCode,
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
        routingCodeIsRequired:
            routingCodeIsRequired ?? this.routingCodeIsRequired,
        routingCode: routingCode ?? this.routingCode,
        bank: country != null && country != this.country
            ? null
            : bank ?? this.bank,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        currency: currency ?? this.currency,
      );

  /// Whether if the new beneficiary can be submitted or not.
  bool get canBeSubmitted =>
      (!shouldSave || (nickname?.isNotEmpty ?? false)) &&
      country != null &&
      ibanOrAccountNO != null &&
      (!routingCodeIsRequired || routingCode != null) &&
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
        routingCodeIsRequired,
        routingCode,
        bank,
        firstName,
        lastName,
        currency,
      ];
}
