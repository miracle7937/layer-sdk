import 'dart:convert';

import '../../../../data_layer/dtos.dart';
import '../../../../data_layer/mappings.dart';
import '../../../models.dart';

/// The new beneficiary transfer flow.
class BeneficiaryTransfer extends NewSchedulableTransfer {
  /// The transfer reason.
  final Message? reason;

  /// A beneficiary that was created during the beneficiary transfer flow.
  final NewBeneficiary? newBeneficiary;

  /// Creates a new [BeneficiaryTransfer].
  BeneficiaryTransfer({
    super.type,
    super.source,
    super.amount,
    super.currency,
    super.destination,
    this.reason,
    super.recurrence = TransferRecurrence.none,
    super.starts,
    super.ends,
    this.newBeneficiary,
  }) : super();

  @override
  bool canBeSubmitted() =>
      type != null &&
      source?.account != null &&
      amount != null &&
      amount! > 0 &&
      currency != null &&
      currency?.code != null &&
      (destination?.beneficiary != null ||
          (newBeneficiary != null &&
              (newBeneficiary?.canBeSubmitted ?? false))) &&
      (recurrence == TransferRecurrence.none || starts != null);

  @override
  BeneficiaryTransfer copyWith({
    TransferType? type,
    NewTransferSource? source,
    double? amount,
    Currency? currency,
    NewTransferDestination? destination,
    Message? reason,
    TransferRecurrence? recurrence,
    DateTime? starts,
    DateTime? ends,
    NewBeneficiary? newBeneficiary,
  }) =>
      BeneficiaryTransfer(
        type: type ?? super.type,
        source: source ?? super.source,
        amount: amount ?? super.amount,
        currency: currency ?? super.currency,
        destination: destination ?? super.destination,
        reason: reason ?? this.reason,
        recurrence: recurrence ?? super.recurrence,
        starts: starts ?? super.starts,
        ends: ends ?? super.ends,
        newBeneficiary: newBeneficiary ?? this.newBeneficiary,
      );

  @override
  NewTransferPayloadDTO toNewTransferPayloadDTO() {
    if (!canBeSubmitted()) {
      throw Exception('Uncompleted transfer');
    }

    return NewTransferPayloadDTO(
      type: type!.toTransferTypeDTO(),
      fromAccountId: source?.account?.id,
      amount: amount!,
      currencyCode: currency!.code!,
      toBeneficiaryId: destination?.beneficiary?.id,
      reason: reason?.id,
      extra: jsonDecode(destination?.beneficiary?.extra ?? ''),
      recurrence: recurrence.toTransferRecurrenceDTO(),
      startDate: starts,
      endDate: ends,
    );
  }

  @override
  List<Object?> get props => [
        type,
        source,
        amount,
        currency,
        destination,
        reason,
        recurrence,
        starts,
        ends,
        newBeneficiary,
      ];
}
