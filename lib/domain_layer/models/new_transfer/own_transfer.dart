import '../../../data_layer/dtos/new_transfer/new_transfer_payload_dto.dart';
import '../../../data_layer/mappings.dart';
import '../../models.dart';

/// The representation of the new own transfer data.
class OwnTransfer extends NewSchedulableTransfer {
  /// Creates new [OwnTransfer].
  OwnTransfer({
    super.source,
    super.destination,
    super.amount,
    super.currency,
    super.scheduleDetails,
    super.saveToShortcut,
    super.transferId,
    super.shortcutName,
  }) : super(type: TransferType.own);

  @override
  bool canBeSubmitted() =>
      source != null &&
      destination != null &&
      amount != null &&
      amount! > 0 &&
      currency != null &&
      (scheduleDetails.recurrence == Recurrence.none ||
          scheduleDetails.startDate != null);

  @override
  OwnTransfer copyWith({
    NewTransferSource? source,
    NewTransferDestination? destination,
    double? amount,
    Currency? currency,
    ScheduleDetails? scheduleDetails,
    bool? saveToShortcut,
    String? shortcutName,
    int? transferId,
  }) =>
      OwnTransfer(
        transferId: transferId ?? this.transferId,
        source: source ?? this.source,
        destination: destination ?? this.destination,
        amount: amount ?? this.amount,
        currency: currency ?? this.currency,
        scheduleDetails: scheduleDetails ?? this.scheduleDetails,
        saveToShortcut: saveToShortcut ?? this.saveToShortcut,
        shortcutName: !(saveToShortcut ?? this.saveToShortcut)
            ? null
            : shortcutName ?? this.shortcutName,
      );

  @override
  NewTransferPayloadDTO toNewTransferPayloadDTO() => NewTransferPayloadDTO(
        fromAccountId: source!.account!.id!,
        toAccountId: destination!.account!.id!,
        type: type!.toTransferTypeDTO(),
        amount: amount!,
        currencyCode: currency!.code!,
        recurrence: scheduleDetails.recurrence.toRecurrenceDTO(),
        startDate: scheduleDetails.startDate,
        endDate: scheduleDetails.endDate,
      );

  @override
  List<Object?> get props => [
        source,
        destination,
        amount,
        currency,
        scheduleDetails,
        saveToShortcut,
        shortcutName,
        transferId,
      ];
}
