import 'dart:convert';

import '../../../data_layer/dtos.dart';
import '../../../data_layer/mappings.dart';
import '../../models.dart';
import '../recurrence/recurrence.dart';

/// The new beneficiary transfer flow.
class BeneficiaryTransfer extends NewSchedulableTransfer {
  /// The transfer reason.
  final Message? reason;

  /// Creates a new [BeneficiaryTransfer].
  BeneficiaryTransfer({
    TransferType? type,
    NewTransferSource? source,
    double? amount,
    Currency? currency,
    NewTransferDestination? destination,
    this.reason,
    Recurrence recurrence = Recurrence.none,
    DateTime? starts,
    DateTime? ends,
  }) : super(
          type: type,
          source: source,
          amount: amount,
          currency: currency,
          destination: destination,
          recurrence: recurrence,
          starts: starts,
          ends: ends,
        );

  @override
  bool canBeSubmitted() =>
      type != null &&
      source?.account != null &&
      amount != null &&
      amount! > 0 &&
      currency != null &&
      currency?.code != null &&
      destination?.beneficiary != null &&
      (recurrence == Recurrence.none || starts != null);

  @override
  BeneficiaryTransfer copyWith({
    TransferType? type,
    NewTransferSource? source,
    double? amount,
    Currency? currency,
    NewTransferDestination? destination,
    Message? reason,
    Recurrence? recurrence,
    DateTime? starts,
    DateTime? ends,
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
      recurrence: recurrence.toRecurrenceDTO(),
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
      ];
}
