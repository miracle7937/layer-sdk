import 'package:equatable/equatable.dart';

import '../../models.dart';

/// Class that holds data for [Mandate]s
class Mandate extends Equatable {
  /// The Id of the mandate
  final int mandateId;

  /// Account used on the mandate
  final String fromAccount;

  /// Card number used on the mandate
  final String fromCard;

  /// Status of the mandate
  final MandateStatus mandateStatus;

  /// Reference for the mandate
  final String reference;

  /// Id of the bank used in the mandate
  final String? bankMandateId;

  /// When it was created
  final DateTime? createdAt;

  /// Last time it was updated
  final DateTime? updatedAt;

  /// Creates a new [Mandate] instance
  const Mandate({
    this.mandateId = 0,
    this.fromAccount = '',
    this.fromCard = '',
    this.reference = '',
    this.mandateStatus = MandateStatus.unknown,
    this.bankMandateId,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props {
    return [
      mandateId,
      fromAccount,
      fromCard,
      mandateStatus,
      reference,
      bankMandateId,
      createdAt,
      updatedAt,
    ];
  }

  /// Makes a copy of the current [Mandate] instance
  Mandate copyWith({
    int? mandateId,
    String? fromAccount,
    String? fromCard,
    MandateStatus? mandateStatus,
    String? reference,
    String? bankMandateId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Mandate(
      mandateId: mandateId ?? this.mandateId,
      fromAccount: fromAccount ?? this.fromAccount,
      fromCard: fromCard ?? this.fromCard,
      mandateStatus: mandateStatus ?? this.mandateStatus,
      reference: reference ?? this.reference,
      bankMandateId: bankMandateId ?? this.bankMandateId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Mandate(mandateId: $mandateId, fromAccount: $fromAccount, '
        'fromCard: $fromCard, mandateStatus: $mandateStatus, '
        'reference: $reference, bankMandateId: $bankMandateId, '
        'createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
