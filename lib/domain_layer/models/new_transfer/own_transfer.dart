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
    super.saveToShortcut,
    super.shortcutName,
  }) : super(type: TransferType.own);

  @override
  bool canBeSubmitted() =>
      source != null &&
      destination != null &&
      amount != null &&
      amount! > 0 &&
      currency != null &&
      (recurrence == Recurrence.none || starts != null);

  @override
  OwnTransfer copyWith({
    NewTransferSource? source,
    NewTransferDestination? destination,
    double? amount,
    Currency? currency,
    bool? saveToShortcut,
    String? shortcutName,
  }) =>
      OwnTransfer(
        source: source ?? this.source,
        destination: destination ?? this.destination,
        amount: amount ?? this.amount,
        currency: currency ?? this.currency,
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
      );

  @override
  List<Object?> get props => [
        source,
        destination,
        amount,
        currency,
        recurrence,
        starts,
        ends,
        saveToShortcut,
        shortcutName,
      ];
}
