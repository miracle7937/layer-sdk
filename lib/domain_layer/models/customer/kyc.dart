import 'package:equatable/equatable.dart';

import '../../../data_layer/extensions.dart';

/// The available statuses for the KYC.
enum KYCStatus {
  /// Is valid.
  valid,

  /// Has expired, but is on the grace period.
  gracePeriod,

  /// Has expired.
  expired,

  /// Unknown.
  unknown,
}

/// The available KYC types
enum KYCGracePeriodType {
  /// Passport KYC
  passport,

  /// ID KYC
  id,

  /// General KYC
  kyc,
}

/// Know-Your-Customer (KYC) status and expiration data.
class KYC extends Equatable {
  /// The Know-Your-Customer (KYC) status for this customer.
  ///
  /// Defaults to [KYCStatus.unknown].
  final KYCStatus status;

  /// The date that the Know-Your-Customer (KYC) of this customer expires.
  final DateTime? expirationDate;

  /// The Know-Your-Customer (KYC) grace period.
  ///
  /// Defaults to `0`.
  final int gracePeriod;

  /// The customer passport grace period.
  final int? passportGracePeriod;

  /// The customer id grace period.
  final int? idGracePeriod;

  /// The customer KYC grace period.
  final int? kycGracePeriod;

  /// Creates a new [KYC].
  const KYC({
    this.status = KYCStatus.unknown,
    this.expirationDate,
    this.gracePeriod = 0,
    this.passportGracePeriod,
    this.idGracePeriod,
    this.kycGracePeriod,
  });

  /// Returns the date that the KYC grace period ends.
  DateTime? get endOfGracePeriod => expirationDate?.addGracePeriod(gracePeriod);

  @override
  List<Object?> get props => [
        status,
        expirationDate,
        gracePeriod,
        passportGracePeriod,
        idGracePeriod,
        kycGracePeriod,
      ];

  /// Returns a copy of the KYC with select different values.
  KYC copyWith({
    KYCStatus? status,
    DateTime? expirationDate,
    int? kycGracePeriod,
    int? idGracePeriod,
    int? passportGracePeriod,
    int? gracePeriod,
  }) =>
      KYC(
        status: status ?? this.status,
        expirationDate: expirationDate ?? this.expirationDate,
        gracePeriod: gracePeriod ?? this.gracePeriod,
        kycGracePeriod: kycGracePeriod ?? this.kycGracePeriod,
        idGracePeriod: idGracePeriod ?? this.idGracePeriod,
        passportGracePeriod: passportGracePeriod ?? this.passportGracePeriod,
      );
}
